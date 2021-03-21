preparation:
• normally use mosesdecoder,
• convert chinese into wuby if needed,
•Regarding data files,
In bilingual, it expects file.src-tgt.lang in both pairs.
In multilingual, it merges all source languages into a single file, and the target language in the same file. e.g. fr+es - en, will expect file.fres-en.fres and file.fres-en.en

