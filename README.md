# Docker-VSCode用テンプレート

## 概要

[柳本和春](https://kazuyanagimoto.com/)さんの[記事](https://zenn.dev/nicetak/articles/vscode-docker-2023)および[GitHubリポジトリ](https://github.com/kazuyanagimoto/dockerR)がベースとなっています。

環境構築について書きましたので、以下をご覧ください。

- [開発コンテナを使って R 環境を構築！](https://yo5uke.github.io/tips/240504_container/)

## ロケール

基本的にこのテンプレートは日本語で構成されるようにしています。

英語で文字化けする際は、日本語ロケールを削除することで自動的に英語ロケールになるので、試してみてください。

1. Dockerfileの`# locale & timezone`の設定を削除
    - `ENV LANG ja_JP.UTF-8`から`RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime`まで
1. docker-compose.ymlの日本語設定を削除
    - environmentの`LANG`, `LANGUAGE`, `LC_ALL`部分
1. コンテナのリビルド