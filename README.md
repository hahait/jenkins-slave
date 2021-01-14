# jenkins-slave
jenkins slave 在 k8s 中运行使用的镜像, 说明如下：
1. 集成了 jenkins-slave, jdk, maven, node, python 和 ssh
2. 由于 jdk1.8.0_111 包太大, 因此没办法传上来, 使用时需要重新下载并解压
3. 使用时, 将 ssh 改为 .ssh, 将 pip 改为 .pip
4. ssh 目录下的 ssh-key, 已经被破坏，不能直接使用，需要自己重新生成
5. 由于镜像底包使用的 Centos-7.9, 以及一些必要的依赖包，因此镜像构建出来会很大（1.5G 左右）
6. 上述 jdk, maven, node, python 可以替换成想要的版本，但是需要具体测试。上面的版本已经测试过是可以正常使用；
