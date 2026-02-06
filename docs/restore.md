# Восстановление мира из бэкапа

1. Останови сервер в панели freegamehost.
2. В облачном хранилище найди `terraria-backups/<SERVER_ID>/<DATE_FOLDER>` и скачай нужный `.wld`.
3. В панели открой Files (или подключись по SFTP) и загрузите `.wld` в папку `REMOTE_WORLD_PATH` (обычно `/home/container/saves/Worlds`).
4. Запусти сервер — мир будет загружен.
