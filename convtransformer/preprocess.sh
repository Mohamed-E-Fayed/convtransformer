src=$1
tgt=$2

TEXT=~/data
OUTPUTPATH=$TEXT

NUM_WORKERS=$(python3 -c "import os; print(os.cpu_count())")

python3 preprocess.py  --source-lang $src --target-lang $tgt \
    --trainpref $TEXT/train.$src-$tgt  --validpref $TEXT/valid.$src-$tgt --testpref $TEXT/test.$src-$tgt \
    --destdir  $OUTPUTPATH  \
    --workers $NUM_WORKERS 

