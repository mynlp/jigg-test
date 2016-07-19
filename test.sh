#!/bin/sh -e

TAGGER_MODEL_NAME=tagger.ser.gz
PARSER_MODEL_NAME=parser.ser.gz
BEAM_SIZE=2
TRAIN_SIZE=100

# Build jigg
cd jigg-develop
./bin/sbt assembly

# Make `result` directory
if [ -e /work/result ]; then
    echo "directory exist."
else
    mkdir /work/result
fi

# Train super tagger
java -Xmx4g -cp ./target/*.jar jigg.nlp.ccg.TrainSuperTagger \
    -bank.lang ja\
    -bank.dir /data/ccgbank-20150216/ \
    -bank.trainSize $TRAIN_SIZE \
    -model /work/result/$TAGGER_MODEL_NAME

# Train parser
java -Xmx5g -cp ./target/*.jar jigg.nlp.ccg.TrainParser \
    -bank.lang ja \
    -bank.dir /data/ccgbank-20150216/ \
    -bank.trainSize $TRAIN_SIZE \
    -beam $BEAM_SIZE \
    -taggerModel /work/result/$TAGGER_MODEL_NAME \
    -model /work/result/$PARSER_MODEL_NAME

# Evaluate accuracy
java -Xmx4g -cp ./target/*.jar jigg.nlp.ccg.EvalJapaneseParser \
    -model /work/result/$PARSER_MODEL_NAME \
    -decoder.beam $BEAM_SIZE \
    -output /work/result/ \
    -bank.dir /data/ccgbank-20150216/ \
    -useTest true \
    -cabocha /data/test.cabocha \
    2>&1 | tee /work/result/eval.log

# Convert evaluation result to xml and json
/work/gen_eval --inputEvalFile /work/result/eval.log \
    --outputEvalDir /work/result

# Convert cabocha to CoNLL format
java -cp ./target/*.jar jigg.nlp.ccg.Cabocha2CoNLL \
    -ccgBank /data/ccgbank-20150216/test.ccgbank \
    -cabocha /data/test.cabocha \
    -output /work/result/test.conll

# Draw prediction result and output
java -jar /work/bin/whatswrong_command-?.?.?-jar-with-dependencies.jar \
    --type CONLL2006 \
    --output /work/output \
    /work/result/pred.conll