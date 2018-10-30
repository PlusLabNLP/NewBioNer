#!/bin/bash

source activate base

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

FOLDER="P2/EXP1" # Fix me!

ORIG_PATH="${2}"
CHECKPOINT_PATH="${3}"
CHECKPOINT_NAME="${4}"

# 1: idea; 2: path to everything 3: base model path; 4: base model name; 5: predict method; 6: sigmoid; 7: char hidden size; 8: word hidden size; 9: restart training
EXEC_NAME="${1}_${3}_${5}_${6}_C${7}_W${8}_Restart${9}_halfway"

SRC_FOLDER="/auto/nlg-05/huan183/NewBioNer"
DATA_FOLDER="$SRC_FOLDER/corpus/train"
CHECKPOINT_FOLDER="$SRC_FOLDER/checkpoints/$FOLDER/$EXEC_NAME"


cd $SRC_FOLDER
mkdir $CHECKPOINT_FOLDER

python3 -u $SRC_FOLDER/train_p2.py \
  --checkpoint $CHECKPOINT_FOLDER \
  --data_loader $SRC_FOLDER/data_loaders/$ORIG_PATH/$CHECKPOINT_PATH/halfway \
  --load_check_point $SRC_FOLDER/checkpoints/$ORIG_PATH/$CHECKPOINT_PATH/$CHECKPOINT_NAME.model \
  --load_arg $SRC_FOLDER/checkpoints/$ORIG_PATH/$CHECKPOINT_PATH/$CHECKPOINT_NAME.json \
  --emb_file /home/nlg-05/lidong/clean_base/MT_NER/external/embedding/wikipedia-pubmed-and-PMC-w2v.txt \
  --train_file \
  $DATA_FOLDER/BC2GM-IOBES/train.tsv \
  $DATA_FOLDER/BC4CHEMD-IOBES/train.tsv \
  $DATA_FOLDER/BC5CDR-IOBES/train.tsv \
  $DATA_FOLDER/NCBI-IOBES/train.tsv \
  $DATA_FOLDER/JNLPBA-IOBES/train.tsv \
  $DATA_FOLDER/linnaeus-IOBES/train.tsv \
  --dev_file \
  $DATA_FOLDER/BC2GM-IOBES/devel.tsv \
  $DATA_FOLDER/BC4CHEMD-IOBES/devel.tsv \
  $DATA_FOLDER/BC5CDR-IOBES/devel.tsv \
  $DATA_FOLDER/NCBI-IOBES/devel.tsv \
  $DATA_FOLDER/JNLPBA-IOBES/devel.tsv \
  $DATA_FOLDER/linnaeus-IOBES/devel.tsv \
  --test_file \
  $DATA_FOLDER/BC2GM-IOBES/test.tsv \
  $DATA_FOLDER/BC4CHEMD-IOBES/test.tsv \
  $DATA_FOLDER/BC5CDR-IOBES/test.tsv \
  $DATA_FOLDER/NCBI-IOBES/test.tsv \
  $DATA_FOLDER/JNLPBA-IOBES/test.tsv \
  $DATA_FOLDER/linnaeus-IOBES/test.tsv \
  --word_dim 200 --char_dim 30 --caseless --fine_tune --shrink_embedding \
  --sigmoid $6 \
  --dispatch N21 --corpus_mask_value 0 \
  --batch_size 10 \
  --least_iters 50 --epoch 500 --patience 30 --stop_on_single \
  --lr 0.01 \
  --gpu 0 \
  --char_hidden $7 \
  --word_hidden $8 \
  --drop_out 0.5 \
  --pickle $SRC_FOLDER/pickle \
  --idea $1 \
  --pred_method $5 \
  --mask_value -1 \
  --restart $9 \
  | tee $SRC_FOLDER/logs/$FOLDER/$EXEC_NAME.log


source deactivate
