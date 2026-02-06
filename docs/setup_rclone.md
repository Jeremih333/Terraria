# Настройка rclone (короткая инструкция)

1. Установи rclone локально: https://rclone.org/install/
2. Запусти `rclone config` → new remote → выбери `drive` (Google Drive) или `dropbox` и пройди авторизацию.
3. После создания remote открой `~/.config/rclone/rclone.conf` (или `%USERPROFILE%/.config/rclone/rclone.conf`)
4. Выполни:
   ```
   cat ~/.config/rclone/rclone.conf | base64
   ```
   и скопируй результат в GitHub Secrets `RCLONE_CONF`.
5. В `RCLONE_REMOTE_NAME` укажи имя remote, которое ты создал (например `gd`).
