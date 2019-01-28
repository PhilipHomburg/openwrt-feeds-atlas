include(utils.m4)dnl Include utility macros
include(repository.m4)dnl Include Repository command
Script(repo_base_uri .. "/lists/base-min.lua")

_FEATURE_GUARD_

Script(repo_base_uri .. "/lists/luci.lua")
Script(repo_base_uri .. "/lists/foris.lua")
Script(repo_base_uri .. "/lists/terminal-apps.lua")

-- IPv6
Install("ds-lite", "6in4", "6rd", "6to4", { priority = 40 })

_END_FEATURE_GUARD_

--[[
We are migrating from uClibc to musl, so reinstall everything depending on libc.
]]
if installed['turris-version'] and version_match(installed['turris-version'].version, '<4.0') then
	Package("libc", { abi_change_deep = true })
	Package('updater-ng', { deps = { 'libgcc' } })
end
