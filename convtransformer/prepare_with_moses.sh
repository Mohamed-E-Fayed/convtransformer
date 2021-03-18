#!/usr/bin/env bash
#
# Adapted from https://github.com/facebookresearch/MIXER/blob/master/prepareData.sh

echo 'Cloning Subword NMT repository (for BPE pre-processing)...'
git clone https://github.com/rsennrich/subword-nmt.git

echo 'Cloning Moses github repository (for tokenization scripts)...'
git clone https://github.com/moses-smt/mosesdecoder.git

SCRIPTS=mosesdecoder/scripts
TOKENIZER=$SCRIPTS/tokenizer/tokenizer.perl
CLEAN=$SCRIPTS/training/clean-corpus-n.perl
NORM_PUNC=$SCRIPTS/tokenizer/normalize-punctuation.perl
REM_NON_PRINT_CHAR=$SCRIPTS/tokenizer/remove-non-printing-char.perl
BPEROOT=subword-nmt/subword_nmt
BPE_TOKENS=50000

src=$1
tgt=$2
lang=en-ar
orig=~/data
prep=$orig/data-bin
tmp=$prep/tmp
NUM_CORES=$(python3 -c "import os; print(os.cpu_count())")

mkdir -p $prep $tmp

echo "#############################################"
echo "pre-processing data..."


echo "pre-processing data..."
for l in $src $tgt; do
    for f in train test valid; do
  if test -f "$tmp/$f.$l"; then
echo "skipping ${tmp}/$f.$l"
    else
        cat $orig/$f.$src-$tgt.$l | \
            perl $NORM_PUNC $l | \
            perl $REM_NON_PRINT_CHAR | \
            perl $TOKENIZER -threads $NUM_CORES -a -l $l >> $orig/$f.$l
    fi
done
done

