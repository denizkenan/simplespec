#!/bin/bash
# check_release.sh - Check GitHub Actions release status

echo "🔍 Checking GitHub Actions Release Status"
echo "========================================"

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo "ℹ️  GitHub CLI not available. Manual check required:"
    echo "   Visit: https://github.com/denizkenan/simplespec/actions"
    echo ""
    exit 0
fi

echo "📋 Recent workflow runs:"
gh run list --limit 5

echo ""
echo "🚀 Latest release workflow:"
gh run list --workflow=release.yml --limit 1

echo ""
echo "🏷️  Recent tags:"
git tag --sort=-version:refname | head -5

echo ""
echo "📦 Check PyPI:"
echo "   https://pypi.org/project/simplespec/"

echo ""
echo "💡 Commands:"
echo "   gh run watch                    # Watch current run"
echo "   gh run view <run-id>           # View specific run details"
echo "   gh run view --log <run-id>     # View logs"
