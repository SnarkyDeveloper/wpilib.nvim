
# wpilib.nvim

An **UNOFFICIAL** Neovim plugin for FRC

---

## Commands
> FRC - Open Health Menu  
> FRC build - Build the project locally  
> FRC teamNumber <team> - Sets project team number  
> FRC simulate <tool> - Opens the simulation menu  
> FRC deploy - Deploys robot code to the robotRIO  
> FRC menu - Shows the new project menu

## TODO
* [-] Add github workflow to update the versions every month
* [-] Initalize .wpilib/wpilib-preferences 

## Installation

### Lazy users

```lua
return {
    'SnarkyDeveloper/wpilib.nvim',
    dependencies = {
        'MunifTanjim/nui.nvim',
    },
    config = function()
        require('wpilib').setup({})
    end,
}
```
