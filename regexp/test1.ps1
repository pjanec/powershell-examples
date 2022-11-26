#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions
'book' -match 'oo'
$s = 'Error #1: UNADDRESSABLE ACCESS of freed memory: writing 0x000002270e8e67a8-0x000002270e8e67b0 8 byte(s)'
$s -match ': UNADDRESSABLE ACCESS'

