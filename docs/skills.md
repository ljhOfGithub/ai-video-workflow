# 相关 Skills 与工具索引

先使用本库的 [ai-video-production](../skills/ai-video-production/SKILL.md) 处理分镜、关键图和验收。已有的专项 Skill 可按素材和目标选择使用。打开上游目录后先核对安装方法、随附文件、依赖与许可。

| 你要做的事 | 现有 Skill | 适用条件 |
| --- | --- | --- |
| 拆出参考视频的构图、切点和声音节奏 | [reel-style-clone](https://github.com/ljhOfGithub/mydotcodex/tree/main/skills/reel-style-clone) | 可以查看完整参考片并获得可信时间点 |
| 规划镜头、旁白和画面对应 | [storyboard-shot-breakdown](https://github.com/ljhOfGithub/mydotcodex/tree/main/skills/storyboard-shot-breakdown) | 已知主题、目标受众和时长 |
| 从口播素材制作短视频 | [video-edit-pipeline](https://github.com/ljhOfGithub/mydotcodex/tree/main/skills/video-edit-pipeline) | 有原始口播素材，按上游要求准备编辑器和检查工具 |
| 检查成片的技术、台词剪切和视听问题 | [video-qa](https://github.com/ljhOfGithub/mydotcodex/tree/main/skills/video-qa) | 成片已导出。有剪辑决策表和词级时间戳时可深入检查剪切边界 |
| 用口播主题制作封面 | [ai-script-cover-generator](https://github.com/ljhOfGithub/mydotcodex/tree/main/skills/ai-script-cover-generator) | 有已核对的内容，另行确认平台比例及文字安全区 |

这些 Skill 有的只是流程入口，运行命令所需的工具和服务以各自文档为准。

## 可选制作工具

- [Hypit](https://github.com/hypit-ai/hypit) 用于描述和执行可复用的视频流程。按官方版本文档核对本地与云端组件。
- [MotionGit 使用指南](https://motiongit.com/use) 介绍如何取得和导出 `.motion` 模板。可下载与再分发权限取决于具体模板及其素材条款。
- [VoxCPM](https://github.com/OpenBMB/VoxCPM) 提供语音合成模型。使用自己或明确授权的参考音频，并按所选版本检查硬件、许可证和模型文档。
- [Clawd Avatar Skill](https://github.com/YANZHANLIN/clawd-avatar-skill) 提供可选的像素角色制作入口。使用前核对上游授权及角色或商标限制。
- [FFmpeg](https://ffmpeg.org/) 用于媒体规格检查、解码和采样。仓库的半秒 OCR 脚本调用 macOS 自带的 AVFoundation 和 Vision。
