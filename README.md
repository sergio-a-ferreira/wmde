* * *
# wmde #

<p align="center">
<img alt="Logo" src="assets/banner.jpg" style="width:80%; height:100px;">
</p>

Window Managers / Desktop Environments configuration files, auxiliary scripts, wallpaper collection

It's like a dotfiles repository for X and graphic systems; for now it's designed for the i3wm + polybar + rofi stack.

* * * 

#### Getting Started ####

Deploy X resource files, like .xinitrc and .Xresources

- ~/.xinitrc: changed to call i3
- ~/.Xresources: added X font and XTerm settings and a color scheme for all programs that use Xresources.
- /etc/X11/xorg.conf.d/00-keyboard.conf: keyboard PT [qwerty] for X applications

Deploy i3 configuration files and scripts



#### Prerequisites ####

.Xresources:

- Mononoki Nerd Font; used in XTerm; may be changed to whatever font you like; to install run:

``` pacman -S --noconfirm --needed ttf-mononoki-nerd  ``` 


- 00-keyboard.conf: needs root previleges to copy to /etc/X11/xorg.conf.d


#### Installation / Deployment ####

create a Projects directory; cd into it and clone the repository:

``` 
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/sergio-a-ferreira/wmde.git
```

Then cd into the project directory and run install.sh

``` 
cd wmde
./install.sh
```


### Authors ####

* **Sergio Ferreira** - *Initial work* - [sergio-a-ferreira](https://github.com/sergio-a-ferreira/wmde.git)


#### License ####

This project is licensed under the Unlicense - see the [LICENSE](LICENSE) file for details
