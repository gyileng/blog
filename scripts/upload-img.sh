#!/usr/bin/env bash
# 用法: ./scripts/upload-img.sh /path/to/image.jpg
# 压缩图片 → 上传到 Cloudflare R2 → 输出 CDN URL

set -e

CDN_BASE="https://img.baiwei.site/img"
R2_BUCKET="r2:nas-blog/img"

if [ -z "$1" ]; then
  echo "用法: $0 /path/to/image.[jpg|jpeg|png]"
  exit 1
fi

SRC="$1"
if [ ! -f "$SRC" ]; then
  echo "错误: 文件不存在: $SRC"
  exit 1
fi

BASENAME=$(basename "$SRC")
EXT="${BASENAME##*.}"
EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')
TMPFILE="/tmp/blog_upload_$$_$BASENAME"

echo "📦 压缩中: $BASENAME"

case "$EXT_LOWER" in
  png)
    pngquant --quality=70-85 --output "$TMPFILE" --force "$SRC" 2>/dev/null || cp "$SRC" "$TMPFILE"
    # 若压缩后反而更大，用原文件
    if [ $(stat -f%z "$TMPFILE") -ge $(stat -f%z "$SRC") ]; then
      cp "$SRC" "$TMPFILE"
      echo "   PNG 已最优，保留原始大小"
    else
      ORIG_KB=$(( $(stat -f%z "$SRC") / 1024 ))
      OPT_KB=$(( $(stat -f%z "$TMPFILE") / 1024 ))
      echo "   ${ORIG_KB}KB → ${OPT_KB}KB"
    fi
    ;;
  jpg|jpeg)
    cp "$SRC" "$TMPFILE"
    jpegoptim --max=85 --strip-all --quiet "$TMPFILE"
    ORIG_KB=$(( $(stat -f%z "$SRC") / 1024 ))
    OPT_KB=$(( $(stat -f%z "$TMPFILE") / 1024 ))
    echo "   ${ORIG_KB}KB → ${OPT_KB}KB"
    ;;
  *)
    cp "$SRC" "$TMPFILE"
    echo "   不支持压缩的格式，直接上传"
    ;;
esac

echo "☁️  上传中..."
rclone copy "$TMPFILE" "$R2_BUCKET" --progress
rm -f "$TMPFILE"

echo ""
echo "✅ 上传完成！复制以下链接到文章："
echo ""
echo "   ${CDN_BASE}/${BASENAME}"
echo ""
