# Проверить что процесс не отвечает и перезапустить в случае чего


if (-not (get-process notepad).responding) {kill -name notepad; notepad}
