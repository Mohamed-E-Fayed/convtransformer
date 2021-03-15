INPUT=~/data/zh-ar
OUTPUT=$INPUT/prepared_chinese

python convert_text.py --input-doc $INPUT --output-doc $OUTPUT --convert-type ch2wb
