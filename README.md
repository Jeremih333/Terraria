# Terraria Backup Automation (GitHub Actions)

Этот репозиторий — готовая, упрощённая и сфокусированная сборка для автоматического создания бэкапов мира Terraria
с хостинга freegamehost.xyz (Pterodactyl-style panel) в облако через `rclone`. Бэкап выполняется каждые 15 минут.

## Что включено
- `.github/workflows/terraria-backup.yml` — GitHub Actions workflow (по расписанию + ручной).
- `scripts/backup.sh` — локальная версия скрипта (для тестирования вручную).
- `docs/` — инструкции и вспомогательные материалы.

## Требуемые секреты (в GitHub repository → Settings → Secrets)
1. `PANEL_URL` — URL панели (например `https://panel.freegamehost.xyz`)
2. `PANEL_API_KEY` — client API key (Bearer) для панели (чтобы отправить команду `save`)
3. `SERVER_ID` — identifier сервера (из панели)
4. `SFTP_HOST` — SFTP host (из панели)
5. `SFTP_PORT` — SFTP port (обычно 2022 or 22)
6. `SFTP_USER` — SFTP username
7. `SFTP_PASS` — SFTP password (если используешь пароль auth)
8. `REMOTE_WORLD_PATH` — пут к папке с мирами (пример: `/home/container/saves/Worlds`)
9. `RCLONE_CONF` — base64-encoded rclone config (`cat ~/.config/rclone/rclone.conf | base64`)
10. `RCLONE_REMOTE_NAME` — имя remote внутри rclone.conf (например `gd`)

> Примечание: для безопасности рекомендуем использовать `rclone` remote с OAuth (Google Drive), затем сохранить `~/.config/rclone/rclone.conf` как base64 в `RCLONE_CONF`.

## Быстрая настройка
1. Создай публичный репозиторий на GitHub (Actions бесплатны для публичных репозиториев).
2. Вставь этот репозиторий (загрузи файлы) либо используй этот zip.
3. Добавь secrets (см. список выше).
4. Убедись, что `REMOTE_WORLD_PATH` точно указывает на место, где находится `*.wld` (открой Files в панели и найди папку `saves/Worlds`).
5. Запусти workflow вручную (Actions → Terraria world backup → Run workflow) для первого теста, или дождись следующего cron запуска.

## Как проверить что всё работает
1. В панели сервера открой консоль и выполни `save` — убедись, что файл .wld обновился.
2. В Actions посмотри лог последнего запуска workflow — шаги: "Trigger server save", "Download world files via SFTP", "Upload to cloud with rclone".
3. Перейди в облако (например Google Drive) и проверь `terraria-backups/<SERVER_ID>/` — в нём должны появиться папки с датой и файлами `.wld` и `.wld.bak`.
4. При необходимости — попробуй восстановить:
   - Останови сервер.
   - Скачай .wld из облака и через Files или SFTP загрузите в `REMOTE_WORLD_PATH`.
   - Запусти сервер — мир восстановится.

## Восстановление (пример)
Если у тебя настроен `rclone` локально и `rclone.conf`, можно выполнить:
```bash
rclone copy gd:terraria-backups/<SERVER_ID>/<DATE_FOLDER> /tmp/terraria_restore --config=rclone.conf
```
Затем загрузи нужные файлы в панель через Files или SFTP.

## Что было сделано нами с оригинального репозитория
Мы:
- Проанализировали исходный архив и выделили только нужные части для резервного копирования мира.
- Убрали лишние сервисные/GUI части, специфичные для других проектов.
- Добавили готовый GitHub Actions workflow и вспомогательный скрипт.
