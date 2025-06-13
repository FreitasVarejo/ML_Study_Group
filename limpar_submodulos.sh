#!/bin/bash

# Submódulo que queremos manter
MANTER="00-Analise_de_Dados/100-pandas-puzzles"

echo "🔍 Submódulos atuais:"
git config --file .gitmodules --get-regexp path | awk '{ print $2 }'

echo "🔧 Removendo submódulos exceto: $MANTER"

# Lista todos os submódulos
git config --file .gitmodules --get-regexp path | awk '{ print $2 }' | while read path; do
    if [ "$path" != "$MANTER" ]; then
        echo "❌ Removendo $path ..."
        git submodule deinit -f "$path"
        git rm -f "$path"
        rm -rf ".git/modules/$path"
    else
        echo "✅ Mantendo $path"
    fi
done

# Atualiza .gitmodules para manter só o submódulo desejado
echo "✏️ Reescrevendo .gitmodules..."
cat > .gitmodules <<EOF
[submodule "$MANTER"]
    path = $MANTER
    url = https://github.com/ajcr/100-pandas-puzzles.git
EOF

# Remove entradas antigas do .git/config
echo "✏️ Limpando .git/config..."
git config -f .git/config --remove-section "submodule.00-Analise_de_Dados/Pierian_Matplotlib" 2>/dev/null

# Etapas finais
git add .gitmodules
git commit -m "Limpando submódulos quebrados, mantendo apenas $MANTER"

echo "✅ Pronto! Agora você pode usar git status normalmente."
