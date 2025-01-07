# 构建指南

使用 `nix shell` 临时命令拉取远程配置文件到本地

``` shell
cd /mnt/etc/nixos
nix shell nixpkgs#git
git clone git@github.com:0x0CFF/NixOS-Configuration.git
```

执行系统构建命令

``` shell
# 使用官方源进行构建
nixos-install --root /mnt

# 使用镜像源进行构建（清华大学）
nixos-install --root /mnt --option substituters "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"

# 使用镜像源进行构建（中国科学技术大学）
nixos-install --root /mnt --option substituters "https://mirrors.ustc.edu.cn/nix-channels/store"

# 使用镜像源进行构建（上海交通大学）
nixos-install --root /mnt --option substituters "https://mirror.sjtu.edu.cn/nix-channels/store"
```

系统构建完成后，根据终端提示设置 root 用户密码