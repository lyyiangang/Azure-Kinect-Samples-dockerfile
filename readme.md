## azure kinect samples dockerfile

这个仓库主要为```Azure-Kinect-Samples```仓库提供docker镜像, 主要参考了[链接](https://pythonlang.dev/repo/rmbashirov-rgbd-kinect-pose/)修改的.
编译分为2步
1. 编译基础镜像

```
cd accept_eula && ./build.sh
```
编译结束时会要求手动输入yes同意license.

2. 编译剩余镜像 

```
cd ../ && ./build.sh
```
3. 运行参考run_local.sh