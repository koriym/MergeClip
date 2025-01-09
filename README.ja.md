# MergeClip

AIとのテキストファイル共有ユーティリティ

拡張子によるアップロード制限やコピー＆ペーストの手間を解消し、
複数ファイルの内容を一度にAIへ効率的に伝えます。

## 概要

MergeClipは、複数のテキストファイルの内容を迅速にマージし、AIチャットボットが理解しやすい形式でMacのクリップボードにコピーするmacOS用ツールです。ファイルを個別に開いてコピー＆ペーストする手間を大幅に削減し、AIとの効率的なコミュニケーションをサポートします。

## 特徴

- 複数のテキストファイルを自動的にマージ
- バイナリファイルを自動的に除外
- 拡張子に基づいて言語を自動識別し、AI対応のフォーマットでコンテンツを構造化
- MacのQuick Action（ファイルやフォルダの選択に対応）とシェルスクリプトの両方で利用可能
- 最大100,000文字まで処理可能
- Finderから実行時はダイアログで処理ファイル数を表示

## インストール

### Quick Actionとして

1. [MergeClip](https://koriym.github.io/MergeClip/MergeClip.zjp)をダウンロード、解凍し、開いてインストール手順に従ってください。

<img width="602" alt="Quick Action Installer" src="https://github.com/koriym/MergeClip/assets/529021/40c2f991-8feb-4145-b0bf-4b6c61ba1930">

（日本語画面の例）

### シェルスクリプトとして

1. [mergeclip.sh](https://koriym.github.io/MergeClip/MergeClip.zip)をダウンロードし、適切な場所に保存します。
2. ターミナルを開き、以下のコマンドを実行してスクリプトを実行可能にします：
   ```
   mv mergeclip.sh /path/to/mergeclip
   chmod +x /path/to/mergeclip
   ```

## 使用方法

### Quick Actionとして

Finderで対象のファイルやフォルダを１つまたは複数選択し、コンテキストメニューから「クイックアクション > MergeClip」を選択します。マージされた内容が自動的にクリップボードにコピーされ、処理されたファイル数がダイアログで表示されます。

<img width="138" alt="Quick Action" src="https://github.com/koriym/MergeClip/assets/529021/bea8eb57-c105-4504-b8ab-87d000ef3d02">

### シェルスクリプトとして

ターミナルで以下のコマンドを実行します：

```
/path/to/mergeclip /path/to/target/folder
```

複数のファイルやフォルダを指定することも可能です：

```
/path/to/mergeclip file1.txt file2.php /path/to/folder1 /path/to/folder2
```

## ユースケース

1. ソースフォルダの内容をAIに説明させる：
   ソースコードが含まれるフォルダをMergeClipで処理し、結果をAIチャットに貼り付けることで、コード全体の説明を効率的に得られます。

2. 複数ファイルの内容を一括で翻訳または分析する：
   MergeClipでファイルをまとめ、AIに一括で翻訳や分析を依頼できます。

## 出力フォーマット

MergeClipは以下のフォーマットでファイル内容をマージします。ファイルの拡張子に基づいて適切な言語タグを自動的に設定します：

````
Filename1.ext
```ext
File1 content
```

Filename2.py
```py
File2 content
```
````

例：
````php
Hello.php
```php
<?php
echo 'Hello';
```
````

このフォーマットにより、AIはファイルの種類と内容を適切に理解し、より正確な応答を生成できます。

## 制限事項

- 最大100,000文字まで処理します。この制限を超えると処理が停止します。
- バイナリファイルは自動的に除外されます。
- MergeClipはmacOS専用で、クリップボード操作に`pbcopy`コマンドを使用します。

---

MergeClipを活用し、AIとのコミュニケーションをより効率的に進めましょう。
