# Kepler installation on GCP

If you try to install Kepler in a GCP environment, you might get the following error:

```
pino@master:~$ k logs --follow -n kepler kepler-exporter-8q6m2
I1209 13:16:40.720431       1 exporter.go:149] Kepler running on version: 8726575
I1209 13:16:40.720512       1 config.go:137] using gCgroup ID in the BPF program: true
I1209 13:16:40.720580       1 config.go:138] kernel version: 5.8
I1209 13:16:40.720611       1 config.go:156] EnabledGPU: true
I1209 13:16:40.721136       1 slice_handler.go:179] Not able to find any valid .scope file in /sys/fs/cgroup/cpu/kubepods.slice, this likely cause all cgroup metrics to be 0
I1209 13:16:40.978676       1 exporter.go:164] Initializing the GPU collector
modprobe: FATAL: Module kheaders not found in directory /lib/modules/5.8.0-1039-gcp
chdir(/lib/modules/5.8.0-1039-gcp/build): No such file or directory
I1209 13:16:40.985243       1 bcc_attacher.go:68] failed to attach the bpf program: <nil>
W1209 13:16:40.985279       1 bcc_attacher.go:113] failed to attach perf module with options [-DNUM_CPUS=2 -DCPU_FREQ]: failed to attach the bpf program: <nil>, Hardware counter related metrics does not exist
modprobe: FATAL: Module kheaders not found in directory /lib/modules/5.8.0-1039-gcp
chdir(/lib/modules/5.8.0-1039-gcp/build): No such file or directory
I1209 13:16:40.989360       1 bcc_attacher.go:68] failed to attach the bpf program: <nil>
I1209 13:16:40.989398       1 bcc_attacher.go:118] failed to attach perf module with options [-DNUM_CPUS=2]: failed to attach the bpf program: <nil>, not able to load eBPF modules
I1209 13:16:40.989420       1 exporter.go:179] failed to start : failed to attach bpf assets: failed to attach the bpf program: <nil>
I1209 13:16:40.989709       1 exporter.go:204] Started Kepler in 269.29575ms
```

To fix it (not the best solution, maybe there are others), just add another volume. This is because inside the kernel directory ehader that Kepler needs to attack ebpf programs, there are some symbolic links that are not mounted in the container.

Just add /usr/src in the deployment.yaml file created during the Kepler installation phase ([Deploy from source codes](https://sustainable-computing.io/installation/kepler/) ) as follows:
```
        volumeMounts:
        - mountPath: /usr/src
          name: usr-src
        .....
      volumes:
      - hostPath:
          path: /usr/src
          type: Directory
        name: usr-src
        ....
```


At the time of writing this file, after installing Kepler, there will always be errors about Kepler failing to attach ebpf programs to the PERF subsystem which does not exist.