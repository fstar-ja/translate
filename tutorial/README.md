## ビルド手順

以下を実行してください。

```
$ sudo apt-get install omake npm
$ npm install -g madoko
$ omake
$ x-www-browser out/tutorial.html
```

## 元文書との同期

FStarリポジトリのdoc/tutorialディレクトリに変更がないか確認してください。

```
$ git clone https://github.com/FStarLang/FStar.git
$ cd FStar
$ git log -p doc/tutorial/
```

修正を見つけたらtutorial.mdkに反映し、以下のようにコミットしてください。

```
$ vi tutorial.mdk
...FStarリポジトリの変更点を反映...
$ git commit -m "Merge 94536c45a0c468b67af7836f3270e70396157311 from FStar"
```

## 用語辞書

翻訳するときは [Dictionary.md](../dictionary/Dictionary.md) ファイルを参照してください。
