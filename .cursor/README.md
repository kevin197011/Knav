# Cursor Rules


## 🚀 部署（Deploy）

快速部署本项目：

```bash
# deploy
rm -rf .cursor && \
git clone git@github.com:kevin197011/cursor.git .cursor && \
( [ ! -f Rakefile ] && mv .cursor/Rakefile . || rm -rf .cursor/Rakefile ) && \
mv .cursor/push.rb . && \
mv .cursor/.rubocop.yml . && \
rm -rf .cursor/.git && \
grep -q '\.cursor' .gitignore 2>/dev/null || printf '\n.cursor\n' >> .gitignore

```

---

更多说明请参考各 rules 文件和脚本注释。
