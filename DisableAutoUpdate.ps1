# 设置更新器路径
$updaterPath = "$env:LOCALAPPDATA\cursor-updater"

Write-Host "正在处理自动更新..."

# 定义手动设置教程
function Show-ManualGuide {
    Write-Host ""
    Write-Host "[警告] 自动设置失败,请尝试手动操作："
    Write-Host "手动禁用更新步骤："
    Write-Host "1. 以管理员身份打开 PowerShell"
    Write-Host "2. 复制粘贴以下命令："
    Write-Host "删除现有目录（如果存在）："
    Write-Host "Remove-Item -Path `"$updaterPath`" -Recurse -Force"
    Write-Host ""
    Write-Host "创建阻止文件："
    Write-Host "New-Item -Path `"$updaterPath`" -ItemType File -Force | Out-Null"
    Write-Host ""
    Write-Host "设置只读属性："
    Write-Host "Set-ItemProperty -Path `"$updaterPath`" -Name IsReadOnly -Value `$true"
    Write-Host ""
    Write-Host "验证方法："
    Write-Host "1. 运行命令：Get-ItemProperty `"$updaterPath`""
    Write-Host "2. 确认 IsReadOnly 属性为 True"
    Write-Host ""
    Write-Host "完成后请重启 Cursor"
    exit
}

# 删除现有目录
if (Test-Path $updaterPath) {
    Write-Host "正在删除 cursor-updater 目录..."
    Remove-Item -Path $updaterPath -Recurse -Force -ErrorAction Stop
    Write-Host "[信息] 成功删除 cursor-updater 目录"
} else {
    Write-Host "[信息] cursor-updater 目录不存在"
}

# 创建阻止文件
New-Item -Path $updaterPath -ItemType File -Force | Out-Null
if ($?) {
    Write-Host "[信息] 成功创建阻止文件"
} else {
    Write-Host "[错误] 创建阻止文件失败"
    Show-ManualGuide
}

# 设置文件权限
Set-ItemProperty -Path $updaterPath -Name IsReadOnly -Value $true -ErrorAction Stop
if ($?) {
    Write-Host "[信息] 成功设置文件权限"
} else {
    Write-Host "[错误] 设置文件权限失败"
    Show-ManualGuide
}

# 验证设置
$fileInfo = Get-ItemProperty $updaterPath
if ($fileInfo.IsReadOnly) {
    Write-Host "[信息] 成功禁用自动更新"
} else {
    Write-Host "[错误] 验证失败：文件权限设置可能未生效"
    Show-ManualGuide
}

# 暂停以查看输出
Read-Host "按回车键退出"