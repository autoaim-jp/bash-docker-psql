# bash-docker-psql

| 作業内容                                | 新しいコンテナ                         | 直接接続                   |
|-----------------------------------------|----------------------------------------|----------------------------|
| バックアップ（平文 pg_dump psqlでリストア） | `backup_by_new_container.sh`           | `backup_by_target_container.sh` |
| バックアップ（バイナリ pg_dump -Fc pg_restoreでリストア） | -                                      | -                          |
| psql                                    | -                                      | `psql_by_target_container.sh` |
| 完全削除（用途なし）                    | -                                      | `delete_by_target_container.sh` |
| リストア（psql）                        | `restore_by_new_container.sh`          | -                          |
| リストア（pg_restore）                  | -                                      | -                          |


# メモ
backup.shのローテーション部分は念の為コメントアウトしてある。  

