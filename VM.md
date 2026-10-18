# VM Setup issue

Windows:

Currently - due to OpenGL limits on windows QEMU the OpenGL version seems to be stuck at 
4.2 whereas some applications need version 4.3+.
A workaround to this is to set:

```
set -gx MESA_GL_VERSION_OVERRIDE 4.3
set -gx MESA_GLSL_VERSION_OVERRIDE 430
```
