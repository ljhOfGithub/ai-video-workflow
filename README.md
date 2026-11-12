# AI 视频制作与验收工作流

一套简体中文工作流，适合用 Codex 等智能体制作短教程、产品演示、口播剪辑和参考片改编。可以只用手册和模板，也可以安装 Skill，把分镜、审核、渲染和验收交给智能体协作完成。

## 五分钟开始

1. 读[制作手册](docs/workflow.md)，决定成片类型、画幅、声源、工具和参考片范围。
2. 复制[分镜与素材表](skills/ai-video-production/references/storyboard.md)，给每个镜头写清楚动作、界面响应和旁白。
3. 从[原创 SVG 道具](props/README.md)取按钮、鼠标指针、进度条或成功图标，或者换成自己的素材。可以先跑[虚构教程示例](docs/example.md)。
4. 做关键画面预览，确认后按分镜制作。导出后填[验收表](skills/ai-video-production/references/qa.md)。

## 安装 Skill

在支持 Agent Skills 的 Codex 项目根目录运行以下命令。仓库内的 `SKILL.md` 与同目录下的脚本、模板需要一起复制。

```bash
git clone https://github.com/ljhOfGithub/ai-video-workflow.git
mkdir -p .agents/skills
cp -R ai-video-workflow/skills/ai-video-production .agents/skills/
```

随后可在 Codex 输入以下提示词。

> 使用 $ai-video-production。做一条面向新手的 15 秒竖屏教程，主题是“如何保存草稿”。先交付分镜表和开头、操作、反馈三个关键画面。通过后再渲染，成片需要字幕、原工程与验收记录。

也可直接使用[相关 Skills 与工具索引](docs/skills.md)组合已有工具。

## 附带内容

- [ai-video-production](skills/ai-video-production/SKILL.md) 负责从需求到交付的流程，含分镜、逐句改写、声音节奏和验收模板。
- [半秒 OCR 脚本](skills/ai-video-production/scripts/ocr_video.swift) 在 macOS 13+ 读取本地视频，输出带请求时间、实际取帧时间、文字和位置的 JSON。
- [原创道具](props/README.md) 可直接引用或自行修改，适合做保存、点击、加载和完成反馈。

原创文档、代码及 SVG 采用 [MIT 许可证](LICENSE)。索引中的第三方工具和素材适用各自的条款。
