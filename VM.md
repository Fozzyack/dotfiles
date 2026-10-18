# VM Setup issue

> [!NOTE]
> This seems to be like a nvidia issue (as per usual)

Currently - due to OpenGL limits on windows QEMU the OpenGL version seems to be stuck at 
4.2 whereas some applications need version 4.3+.

> [!INFO]
> It seems like this is a known VirGL design limitation that has affected nvidia users for years

A workaround to this is to set:

```
MESA_GL_VERSION_OVERRIDE 4.3
MESA_GLSL_VERSION_OVERRIDE 430
```

You can set it in hyprland or in `~/.profile`
