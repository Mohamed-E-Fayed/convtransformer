#!/usr/bin/env bash
#
# Adapted from https://github.com/facebookresearch/MIXER/blob/master/prepareData.sh

echo 'Cloning Subword NMT repository (for BPE pre-processing)...'
git clone https://github.com/rsennrich/subword-nmt.git

echo 'Cloning Moses github repository (for tokenization scripts)...'
git clone https://github.com/moses-smt/mosesdecoder.git

echo "cloning wmt-en2wubi... (it is useful only in converting chinese text to wubi format to be suitable for character based translation)"
git clone https://github.com/duguyue100/wmt-en2wubi

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
#orig=/mnt/az_file_share/fayed/data/${src}-${tgt}
orig=~/data/${src}-${tgt}
tmp=$orig/tmp
NUM_CORES=$(python3 -c "import os; print(os.cpu_count())")
MAIN_DIRECTORY=$PWD

mkdir -p $tmp

echo "using moses on data..."
for l in $src $tgt; do
    for f in train test valid; do
  if test -f "$orig/$f.$l"; then
echo "skipping ${orig}/$f.$l"
    else
        cat $orig/$f.$src-$tgt.$l | \
            perl $NORM_PUNC $l | \
            perl $REM_NON_PRINT_CHAR | \
            perl $TOKENIZER -no-escape -threads $NUM_CORES -a -l $l >> $orig/$f.$l
  if [ $l = "zh" ] ; then
	  echo "converting ${f}.${l} content into wubi..."
    mv $orig/$f.$l $tmp/
    # Using python3 convert_text.py command is influenced by main github repo of convtransformer
    # the make commands are inspired by the wmt-en2wubi repo
    cd wmt-en2wubi/en2wubi
    #CONVERT_INTO_WUBI_SCRIPT_PATH=wmt-en2wubi/en2wubi/en2wubi
    #cd $CONVERT_INTO_WUBI_SCRIPT_PATH
    #python3 ./scripts/convert_text.py   --input-doc $tmp/$f.$l  --output-doc $orig/$f.$l --convert-type en2wb
    make convert-cn2wb IN=$tmp/$f.$l  OUT=$orig/$f.$l # CN2WB
    cd $MAIN_DIRECTORY #return to convtransformer/convtransformer directory
  fi
    fi
done
done

