mkdir -p .git/hooks
touch .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
echo "#!/bin/bash
dart fix --apply && dart format --fix .
" >> .git/hooks/pre-commit