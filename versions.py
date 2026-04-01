from github import Github

g = Github()

wpiorg = g.get_organization('wpilibsuite')


def wpilib() -> str:
    lua = 'return {\n'
    for rel in wpiorg.get_repo('allwpilib').get_releases():
        version = rel.tag_name.removeprefix('v')

        if rel.prerelease:
            if not ('2016' in version or '2017' in version or '2018' in version):
                lua = ''.join([lua, f'  {{ tag = \'{version}\', stable = false }},\n'])
        else:
            if not ('2016' in version or '2017' in version or '2018' in version):
                lua = ''.join([lua, f'  {{ tag = \'{version}\', stable = true }},\n'])
    return lua

lua = wpilib()

with open('versions.lua', 'w', encoding='utf8') as f:
    lua = ''.join([lua, '}'])
    f.write(lua)
