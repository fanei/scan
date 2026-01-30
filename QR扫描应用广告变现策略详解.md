# QR 扫描应用广告变现策略详解

## 如何优雅地实现广告变现而不破坏用户体验

**文档版本**：v1.0
**创建日期**：2026年1月29日

---

## 📋 目录

- [一、移动广告平台选择](#一移动广告平台选择)
- [二、广告形式分析](#二广告形式分析)
- [三、我们推荐的广告策略](#三我们推荐的广告策略)
- [四、技术实现方案](#四技术实现方案)
- [五、广告优化策略](#五广告优化策略)
- [六、用户体验平衡](#六用户体验平衡)
- [七、收入预测](#七收入预测)
- [八、合规与安全](#八合规与安全)

---

## 一、移动广告平台选择

### 1.1 主流广告平台对比

| 平台 | eCPM (美国) | 填充率 | 优点 | 缺点 | 推荐度 |
|------|:-----------:|:------:|------|------|:------:|
| **Google AdMob** | $8-15 | 95%+ | 官方支持，稳定 | 分成比例30% | ⭐⭐⭐⭐⭐ |
| **Meta Audience Network** | $10-20 | 90%+ | eCPM 高，精准 | 需要 Facebook SDK | ⭐⭐⭐⭐⭐ |
| **Unity Ads** | $12-25 | 85%+ | 游戏类收益高 | 非游戏应用适配一般 | ⭐⭐⭐⭐ |
| **AppLovin MAX** | $10-18 | 92%+ | 瀑布流，收益优化 | 学习曲线陡 | ⭐⭐⭐⭐⭐ |
| **ironSource** | $8-15 | 88%+ | 聚合平台 | 主要针对游戏 | ⭐⭐⭐ |
| **Start.io** | $6-12 | 85%+ | 适合工具类 | eCPM 较低 | ⭐⭐⭐⭐ |

### 1.2 推荐方案：AdMob + Audience Network 聚合

```
为什么选择这个组合：

AdMob（主要）：
├─ Google 官方平台，最稳定
├─ SDK 成熟，文档完善
├─ 支持所有广告格式
├─ 全球覆盖，填充率高
└─ 与 Firebase 深度集成

Audience Network（辅助）：
├─ Meta 的精准定向
├─ eCPM 通常更高
├─ 广告质量较好
└─ 可以作为 AdMob 的瀑布流

聚合策略：
├─ AdMob 作为主要来源（70%）
├─ Audience Network 作为补充（30%）
└─ 使用 AdMob 瀑布流自动优化
```

### 1.3 平台快速对比

#### Google AdMob

```gradle
// build.gradle
dependencies {
    implementation 'com.google.android.gms:play-services-ads:22.6.0'
}

// 优点
✅ Google 官方，最稳定
✅ SDK 文档完善
✅ 全球广告主资源
✅ 实时竞价（RTB）
✅ 与 Firebase Analytics 集成

// 缺点
❌ 分成比例 30%（广告主 70%，开发者 70%）
❌ 审核严格（2-3天）
❌ 账户容易被暂停

// 适用场景
- 工具类应用首选
- 追求稳定性
- 全球用户
```

#### Meta Audience Network

```gradle
// build.gradle
dependencies {
    implementation 'com.facebook.android:audience-network-sdk:6.16.0'
}

// 优点
✅ eCPM 通常比 AdMob 高 20-40%
✅ Meta 的用户画像精准
✅ 原生广告体验好
✅ Instagram/Facebook 广告资源

// 缺点
❌ 需要 Facebook SDK
❌ 主要针对 Meta 生态用户
❌ 填充率在某些地区较低

// 适用场景
- 社交属性强的应用
- 用户画像清晰
- 追求高 eCPM
```

#### AppLovin MAX（聚合平台）

```gradle
// build.gradle
dependencies {
    implementation 'com.applovin:applovin-sdk:11.11.3'
}

// 优点
✅ 瀑布流自动优化
✅ 支持多家广告网络
✅ 实时竞价
✅ eCPM 优化算法
✅ 统一的报表和分析

// 缺点
❌ 学习曲线陡
❌ 配置复杂
❌ 需要技术团队维护

// 适用场景
- 大规模应用（100K+ MAU）
- 有技术团队
- 追求收益最大化
```

---

## 二、广告形式分析

### 2.1 移动广告形式全景图

```
移动广告形式分类：

┌─────────────────────────────────────────┐
│         展示类广告（Display）            │
├─────────────────────────────────────────┤
│ 1. Banner（横幅）                        │
│ 2. Interstitial（插屏）                 │
│ 3. Native（原生）                        │
│ 4. Rewarded Video（激励视频）           │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│         互动类广告（Interactive）         │
├─────────────────────────────────────────┤
│ 5. Playable（可玩广告）                 │
│ 6. Offerwall（ offer 墙）               │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│         新兴形式（Emerging）              │
├─────────────────────────────────────────┤
│ 7. Rewarded Interstitial（激励插屏）     │
│ 8. Native Banner（原生横幅）             │
│ 9. Adaptive Banner（自适应横幅）         │
└─────────────────────────────────────────┘
```

### 2.2 各广告形式详细分析

#### 1. Banner（横幅广告）

```
特点：
├─ 尺寸固定或自适应
├─ 位置：顶部/底部
├─ 展示时间：持续
├─ 交互：点击跳转
└─ eCPM：$0.5-2（工具类）

优点：
✅ 不干扰用户体验
✅ 实现简单
✅ 持续曝光
✅ 适合长期收益

缺点：
❌ 点击率低（0.1-0.5%）
❌ 收益较低
❌ 占用屏幕空间
❌ 视觉干扰

适用场景：
├─ 设置页面
├─ 历史记录页面底部
└─ 结果页面底部

推荐度：⭐⭐⭐⭐
```

#### 2. Interstitial（插屏广告）

```
特点：
├─ 全屏展示
├─ 时机：自然中断点
├─ 展示时间：3-5秒可跳过
├─ 交互：点击跳转/关闭
└─ eCPM：$8-15（工具类）

优点：
✅ 曝光率高
✅ eCPM 较高
✅ 收益好

缺点：
❌ 用户体验干扰大
❌ 过度使用导致用户流失
❌ 容易误触

适用场景：
├─ 扫描结果展示后（谨慎）
├─ 退出应用前
└─ 完成某个任务后

推荐度：⭐⭐⭐（需谨慎使用）
```

#### 3. Native Ads（原生广告）

```
特点：
├─ 融入应用 UI
├─ 自定义样式
├─ 体验接近原生内容
├─ 交互：自然点击
└─ eCPM：$5-12（工具类）

优点：
✅ 用户体验最好
✅ 点击率较高（1-2%）
✅ 不破坏应用体验
✅ 可自定义样式

缺点：
❌ 实现复杂
❌ 需要设计适配
❌ AdMob 原生广告有一定限制

适用场景：
├─ 历史记录列表中（作为一项）
├─ 功能推荐列表
└─ 设置页面推荐区域

推荐度：⭐⭐⭐⭐⭐（强烈推荐）
```

#### 4. Rewarded Video（激励视频）

```
特点：
├─ 全屏视频 15-30秒
├─ 用户主动选择观看
├─ 观看完成后获得奖励
├─ 完成率：60-80%
└─ eCPM：$15-30（工具类）

优点：
✅ eCPM 最高
✅ 用户主动选择
✅ 接受度高
✅ 完成率高

缺点：
❌ 需要设计奖励机制
❌ 不适合所有应用
❌ 需要广告库存

适用场景：
├─ 解锁高级功能
├─ 云同步配额
├─ 批量生成次数
└─ 去广告时长

推荐度：⭐⭐⭐⭐（需要设计奖励机制）
```

#### 5. Rewarded Interstitial（激励插屏）

```
特点：
├─ 插屏 + 激励结合
├─ 可选择观看
├─ 观看获得奖励
├─ 跳过无奖励
└─ eCPM：$12-25

优点：
✅ 平衡体验和收益
✅ 用户可选择
✅ eCPM 较高

缺点：
❌ 设计复杂
❌ 仍有一定干扰

适用场景：
├─ 扫描完成后
├─ 生成 QR 完成后
└─ 导出数据前

推荐度：⭐⭐⭐⭐
```

### 2.3 各形式推荐度总结

| 广告形式 | 收益潜力 | 用户体验 | 实现难度 | 推荐度 |
|---------|:--------:|:--------:|:--------:|:------:|
| Banner | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐ | ⭐⭐⭐⭐ |
| Interstitial | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| Native Ads | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Rewarded Video | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| Rewarded Interstitial | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

---

## 三、我们推荐的广告策略

### 3.1 核心原则

```
用户体验优先原则：

❌ 不做：
├─ 扫描结果中插入广告（Gamma Play 的问题）
├─ 伪装成按钮的广告
├─ 无法关闭的广告
├─ 恶意广告（钓鱼、欺诈）
└─ 过度频繁的插屏

✅ 要做：
├─ 明确标识广告
├─ 可选的激励广告
├─ 不干扰核心功能
├─ 优雅的原生广告
└─ 用户可控的频率
```

### 3.2 推荐的广告组合

```
Phase 1 (MVP) - 最小干扰模式：

1. Banner 广告（基础）
   ├─ 位置：设置页面底部
   ├─ 频率：持续展示
   └─ 收益占比：30%

2. 原生广告（推荐）
   ├─ 位置：历史记录列表（每5项插入1个）
   ├─ 样式：与列表项融合
   ├─ 标识："广告"标签
   └─ 收益占比：50%

3. 激励视频（增值）
   ├─ 触发：用户主动点击
   ├─ 奖励：解锁云同步（7天）
   ├─ 奖励：批量生成 QR（5个）
   └─ 收益占比：20%

总预计 eCPM：$8-12
```

### 3.3 各页面广告策略

```
扫描页面（主页）：
├─ ❌ 不展示广告（核心功能页面）
├─ ✅ 保持界面简洁
└─ ✅ 专注于扫描体验

结果页面：
├─ ❌ 不展示插屏广告（避免误触）
├─ ✅ 可选：底部小 Banner
└─ ✅ 可选：激励视频按钮（获得额外功能）

历史记录页面：
├─ ✅ 原生广告（插入列表）
├─ 规则：每 5 个真实项插入 1 个广告
├─ 样式：与列表项类似但有明确标识
└─ "🔍 促销：扫描新工具" (广告)

生成 QR 页面：
├─ ❌ 不展示广告（创作过程）
├─ ✅ 生成完成后可选激励视频
└─ 奖励：解锁高级自定义选项

设置页面：
├─ ✅ 底部 Banner
├─ ✅ 功能推荐区（原生广告）
└─ ❌ 避免干扰设置操作
```

### 3.4 广告频率控制

```kotlin
// 广告频率管理器
class AdFrequencyManager @Inject constructor(
    private val preferences: DataStore<Preferences>
) {
    companion object {
        const val INTERSTITIAL_INTERVAL = 3 // 每3次操作
        const val DAILY_INTERSTITIAL_MAX = 3 // 每日最多3次
        const val DAILY_REWARDED_MAX = 10 // 每日最多10次激励视频
    }

    // 检查是否可以展示插屏广告
    suspend fun canShowInterstitial(): Boolean {
        val count = preferences.getData(INTERSTITIAL_COUNT, 0)
        val lastShowTime = preferences.getData(LAST_INTERSTITIAL_TIME, 0L)
        val todayStart = getTodayStartTime()

        // 如果是新的日期，重置计数
        if (lastShowTime < todayStart) {
            preferences.saveData(INTERSTITIAL_COUNT, 0)
            return true
        }

        // 检查每日上限
        if (count >= DAILY_INTERSTITIAL_MAX) {
            return false
        }

        return true
    }

    // 记录插屏广告展示
    suspend fun recordInterstitialShown() {
        val count = preferences.getData(INTERSTITIAL_COUNT, 0)
        preferences.saveData(INTERSTITIAL_COUNT, count + 1)
        preferences.saveData(LAST_INTERSTITIAL_TIME, System.currentTimeMillis())
    }

    // 检查是否可以展示激励视频
    suspend fun canShowRewardedVideo(): Boolean {
        val count = preferences.getData(REWARDED_COUNT, 0)
        val todayStart = getTodayStartTime()
        val lastReset = preferences.getData(LAST_REWARDED_RESET, 0L)

        // 新的一天，重置
        if (lastReset < todayStart) {
            preferences.saveData(REWARDED_COUNT, 0)
            preferences.saveData(LAST_REWARDED_RESET, System.currentTimeMillis())
            return true
        }

        return count < DAILY_REWARDED_MAX
    }

    private fun getTodayStartTime(): Long {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)
        return calendar.timeInMillis
    }
}
```

---

## 四、技术实现方案

### 4.1 AdMob 集成

#### 步骤 1：添加依赖

```gradle
// build.gradle (Project)
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}

// build.gradle (App)
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'com.google.gms.google-services'
}

dependencies {
    implementation 'com.google.android.gms:play-services-ads:22.6.0'
}
```

#### 步骤 2：初始化 SDK

```kotlin
// Application.kt
class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        // 初始化 AdMob
        MobileAds.initialize(this) { initializationStatus ->
            val statusMap = initializationStatus.adapterStatusMap
            // 记录初始化状态
            statusMap.forEach { (adapterClass, status) ->
                Log.d("AdMob", "Adapter: $adapterClass, Status: $status")
            }
        }

        // 设置测试设备 ID（开发阶段）
        val testDeviceIds = listOf("33BE2250B43518CCDA7DE426D04EE231") // 示例
        val configuration = RequestConfiguration.Builder()
            .setTestDeviceIds(testDeviceIds)
            .build()
        MobileAds.setRequestConfiguration(configuration)
    }
}
```

#### 步骤 3：Banner 广告实现

```kotlin
@Composable
fun BannerAdView(
    adUnitId: String,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val adSize = remember {
        // 根据屏幕宽度选择合适的广告尺寸
        val windowMetrics = WindowMetricsCalculator.getOrCreate()
        val bounds = windowMetrics.computeCurrentWindowBounds(context)
        val width = bounds.width().toInt()
        getAdaptiveAdSize(context, width)
    }

    AndroidView(
        factory = { context ->
            AdView(context).apply {
                setAdSize(adSize)
                setAdUnitId(adUnitId)

                // 加载广告
                val adRequest = AdRequest.Builder().build()
                loadAd(adRequest)

                // 广告监听
                adListener = object : AdListener() {
                    override fun onAdLoaded() {
                        Log.d("BannerAd", "广告加载成功")
                    }
                    override fun onAdFailedToLoad(error: LoadAdError) {
                        Log.e("BannerAd", "广告加载失败: ${error.message}")
                    }
                    override fun onAdOpened() {
                        Log.d("BannerAd", "广告被点击")
                    }
                    override fun onAdClosed() {
                        Log.d("BannerAd", "广告关闭")
                    }
                }
            }
        },
        modifier = modifier
    )
}

// 获取自适应广告尺寸
fun getAdaptiveAdSize(context: Context, width: Int): AdSize {
    val density = context.resources.displayMetrics.density
    val adWidth = (width / density).toInt()

    return AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(context, adWidth)
}

// 使用示例
@Composable
fun SettingsScreen() {
    Column(
        modifier = Modifier.fillMaxSize()
    ) {
        // 设置内容
        SettingsContent()

        Spacer(modifier = Modifier.weight(1f))

        // 底部 Banner 广告
        BannerAdView(
            adUnitId = "ca-app-pub-3940256099942544/6300978111", // 测试 ID
            modifier = Modifier
                .fillMaxWidth()
                .height(50.dp)
        )
    }
}
```

#### 步骤 4：原生广告实现

```kotlin
// 原生广告模板
@Composable
fun NativeAdView(
    nativeAd: UnifiedNativeAd,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier
            .fillMaxWidth()
            .padding(8.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(
            modifier = Modifier.padding(12.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            // 广告标识
            Text(
                "广告",
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.tertiary,
                modifier = Modifier.align(Alignment.End)
            )

            // 标题
            Text(
                nativeAd.headline,
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            // 广告主名称
            nativeAd.advertiser?.let { advertiser ->
                Text(
                    advertiser,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }

            // 图标
            nativeAd.icon?.let { icon ->
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    AsyncImage(
                        model = icon.drawable,
                        contentDescription = null,
                        modifier = Modifier.size(24.dp)
                    )

                    // Call to Action 按钮
                    Button(
                        onClick = { nativeAd.performClick() },
                        modifier = Modifier.weight(1f)
                    ) {
                        Text(nativeAd.callToAction ?: "了解更多")
                    }
                }
            }

            // 图片（如果有）
            nativeAd.images?.firstOrNull()?.let { image ->
                AsyncImage(
                    model = image.drawable,
                    contentDescription = null,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(120.dp)
                        .clip(MaterialTheme.shapes.medium)
                )
            }
        }
    }
}

// 原生广告加载器
class NativeAdLoader @Inject constructor() {
    private val adLoader = AdLoader.Builder(context, AD_UNIT_ID)
        .forUnifiedNativeAd { unifiedNativeAd ->
            // 处理加载的原生广告
            _nativeAd.value = unifiedNativeAd
        }
        .withAdListener(object : AdListener() {
            override fun onAdLoaded() {
                // 广告加载成功
            }
            override fun onAdFailedToLoad(error: LoadAdError) {
                // 广告加载失败
            }
        })
        .build()

    fun loadAd() {
        val builder = AdRequest.Builder()
        val videoOptions = VideoOptions.Builder()
            .setStartMuted(true)
            .build()

        val adOptions = NativeAdOptions.Builder()
            .setVideoOptions(videoOptions)
            .build()

        val adRequest = builder.build()
        adLoader.loadAd(UnifiedNativeAdOptions.builder()
            .setAdChoicesPlacement(AdChoicesPlacement.BOTTOM_RIGHT)
            .build())
    }
}

// 在历史记录中使用
@Composable
fun ScanHistoryList(
    history: List<ScanRecord>,
    modifier: Modifier = Modifier
) {
    val nativeAd by viewModel.nativeAd.collectAsState()

    LazyColumn(
        modifier = modifier,
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        itemsIndexed(history) { index, item ->
            // 每 5 个项插入一个原生广告
            if (index > 0 && index % 5 == 0 && nativeAd != null) {
                item {
                    NativeAdView(
                        nativeAd = nativeAd!!,
                        modifier = Modifier.fillMaxWidth()
                    )
                }
            }

            // 正常的历史记录项
            item {
                ScanHistoryItem(record = item)
            }
        }
    }
}
```

#### 步骤 5：激励视频广告

```kotlin
// 激励视频管理器
class RewardedAdManager @Inject constructor(
    private val context: Context,
    private val frequencyManager: AdFrequencyManager
) {
    private var rewardedAd: RewardedAd? = null
    private var reloadCallback: (() -> Unit)? = null

    // 加载激励视频
    fun loadAd(adUnitId: String, onLoaded: () -> Unit, onFailed: (LoadAdError) -> Unit) {
        RewardedAd.load(context, adUnitId,
            AdRequest.Builder().build(),
            object : RewardedAdLoadCallback() {
                override fun onAdLoaded(ad: RewardedAd) {
                    rewardedAd = ad
                    onLoaded()
                }

                override fun onAdFailedToLoad(error: LoadAdError) {
                    rewardedAd = null
                    onFailed(error)
                }
            })
    }

    // 展示激励视频
    fun show(
        activity: Activity,
        onUserEarnedReward: (RewardItem) -> Unit,
        onAdFailedToShow: (Int) -> Unit,
        onAdDismissed: () -> Unit
    ) {
        val ad = rewardedAd
        if (ad == null) {
            onAdFailedToShow(AdRequest.ERROR_CODE_NO_FILL)
            return
        }

        ad.fullScreenContentCallback = object : FullScreenContentCallback() {
            override fun onAdShowed() {
                // 广告展示
            }

            override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                onAdFailedToShow(adError.code)
                rewardedAd = null
            }

            override fun onAdDismissedFullScreenContent() {
                onAdDismissed()
                rewardedAd = null
                reloadCallback?.invoke()
            }
        }

        ad.show(activity, object : OnUserEarnedRewardListener {
            override fun onUserEarnedReward(reward: RewardItem) {
                onUserEarnedReward(reward)
            }
        })
    }

    // 检查广告是否已加载
    fun isAdLoaded(): Boolean = rewardedAd != null
}

// 使用示例
@Composable
fun QRGeneratorScreen(
    viewModel: QRGeneratorViewModel = hiltViewModel()
) {
    val context = LocalContext.current
    val activity = context as Activity
    val rewardedAdManager: RewardedAdManager = remember { RewardedAdManager(context) }

    var showRewardedDialog by remember { mutableStateOf(false) }

    // 加载广告
    LaunchedEffect(Unit) {
        rewardedAdManager.loadAd(
            adUnitId = "ca-app-pub-3940256099942544/5224354917", // 测试 ID
            onLoaded = { /* 广告已加载 */ },
            onFailed = { /* 广告加载失败 */ }
        )
    }

    Column {
        // 生成按钮
        Button(onClick = {
            if (rewardedAdManager.isAdLoaded()) {
                showRewardedDialog = true
            } else {
                // 直接生成
                viewModel.generateQR()
            }
        }) {
            Text("生成 QR 码")
        }

        // 激励视频对话框
        if (showRewardedDialog) {
            AlertDialog(
                onDismissRequest = { showRewardedDialog = false },
                title = { Text("解锁高级功能") },
                text = {
                    Text("观看短视频广告，解锁高级自定义选项（Logo、颜色、形状）")
                },
                confirmButton = {
                    Button(onClick = {
                        showRewardedDialog = false
                        rewardedAdManager.show(
                            activity = activity,
                            onUserEarnedReward = { reward ->
                                // 解锁高级功能
                                viewModel.unlockPremiumFeatures()
                            },
                            onAdFailedToShow = {
                                // 广告展示失败，使用基础功能
                                viewModel.generateQR()
                            },
                            onAdDismissed = {
                                // 广告关闭
                            }
                        )
                    }) {
                        Text("观看广告")
                    }
                },
                dismissButton = {
                    TextButton(onClick = { showRewardedDialog = false }) {
                        Text("取消")
                    }
                }
            )
        }
    }
}
```

---

## 五、广告优化策略

### 5.1 A/B 测试

```kotlin
// A/B 测试配置器
class AdExperimentManager @Inject constructor(
    private val remoteConfig: FirebaseRemoteConfig
) {
    // 获取当前实验配置
    fun getExperimentConfig(): AdConfig {
        return AdConfig(
            bannerFrequency = remoteConfig.getDouble("banner_frequency").toInt(),
            interstitialFrequency = remoteConfig.getDouble("interstitial_frequency").toInt(),
            rewardedEnabled = remoteConfig.getBoolean("rewarded_enabled"),
            nativeAdEnabled = remoteConfig.getBoolean("native_ad_enabled")
        )
    }

    // 记录实验事件
    fun logExperimentEvent(
        experimentName: String,
        variant: String,
        eventName: String
    ) {
        Firebase.analytics.logEvent("ad_experiment") {
            param("experiment", experimentName)
            param("variant", variant)
            param("event", eventName)
        }
    }
}

data class AdConfig(
    val bannerFrequency: Int = 1,
    val interstitialFrequency: Int = 3,
    val rewardedEnabled: Boolean = true,
    val nativeAdEnabled: Boolean = true
)
```

### 5.2 实时竞价（RTB）

```
AdMob 自动参与 RTB：

实时竞价优势：
├─ 多个广告主竞争
├─ 价格透明
├─ 收益最大化
└─ 自动优化

参与方式：
├─ AdMob 默认启用 RTB
├─ 无需额外配置
├─ 自动选择最高出价
└─ 提升整体 eCPM 20-40%
```

### 5.3 广告刷新策略

```kotlin
// Banner 广告刷新管理器
class BannerRefreshManager {
    companion object {
        private const val REFRESH_INTERVAL = 60_000L // 60秒
    }

    fun startRefreshing(adView: AdView) {
        val handler = Handler(Looper.getMainLooper())
        val runnable = object : Runnable {
            override fun run() {
                adView.loadAd(AdRequest.Builder().build())
                handler.postDelayed(this, REFRESH_INTERVAL)
            }
        }
        handler.postDelayed(runnable, REFRESH_INTERVAL)
    }
}
```

### 5.4 广告收入分析

```kotlin
// 广告收入追踪器
class AdRevenueTracker @Inject constructor() {
    fun trackAdRevenue(
        adFormat: String,
        adUnitId: String,
        revenue: Double,
        currencyCode: String = "USD"
    ) {
        Firebase.analytics.logEvent("ad_impression") {
            param("ad_format", adFormat)
            param("ad_unit_id", adUnitId)
            param("value", revenue)
            param("currency", currencyCode)
        }

        // 同时发送到 AdMob SDK（自动）
        val impression = Impression(
            Impression.UNIFIED_NATIVE_AD,
            adUnitId,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            0L,
            0L,
            null
        )
        MobileAds.incrementalImpressionTracking(impression)
    }
}
```

---

## 六、用户体验平衡

### 6.1 广告展示原则

```
黄金法则：

✅ 正确做法：
├─ 明确标识广告
├─ 不干扰核心功能
├─ 提供价值交换（激励广告）
├─ 用户可控（频率限制）
└─ 时机的选择（自然中断点）

❌ 避免做法：
├─ 扫描结果中插入广告
├─ 伪装成 UI 的广告
├─ 无法跳过的广告
├─ 过度频繁的插屏
└─ 危险/误导性广告
```

### 6.2 用户反馈机制

```kotlin
// 广告反馈收集器
class AdFeedbackManager @Inject constructor() {
    fun collectFeedback(
        adType: String,
        feedback: AdFeedback
    ) {
        Firebase.analytics.logEvent("ad_feedback") {
            param("ad_type", adType)
            param("feedback_type", feedback.type)
            param("feedback_value", feedback.value)
            param("user_id", getUserId())
        }
    }
}

enum class AdFeedback {
    INTRUSIVE,
    IRRELEVANT,
    INAPPROPRIATE,
    TOO_FREQUENT,
    OTHER
}

// 用户可以直接报告广告
@Composable
fun AdReportButton(
    adType: String,
    onReport: (AdFeedback) -> Unit
) {
    var showDialog by remember { mutableStateOf(false) }

    IconButton(onClick = { showDialog = true }) {
        Icon(
            imageVector = Icons.Outlined.Flag,
            contentDescription = "举报广告",
            tint = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }

    if (showDialog) {
        AlertDialog(
            onDismissRequest = { showDialog = false },
            title = { Text("举报广告") },
            text = {
                Column(
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Text("请选择举报原因：")
                    AdFeedback.values().forEach { feedback ->
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier
                                .fillMaxWidth()
                                .clickable {
                                    onReport(feedback)
                                    showDialog = false
                                }
                                .padding(8.dp)
                        ) {
                            RadioButton(
                                selected = false,
                                onClick = null
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(feedback.name)
                        }
                    }
                }
            },
            confirmButton = {
                TextButton(onClick = { showDialog = false }) {
                    Text("取消")
                }
            }
        )
    }
}
```

### 6.3 无广告选项

```kotlin
// 无广告管理器
class AdFreeManager @Inject constructor(
    private val billingManager: BillingManager,
    private val preferences: DataStore<Preferences>
) {
    companion object {
        const val AD_FREE_SKU = "ad_free_lifetime"
    }

    // 检查是否无广告
    suspend fun isAdFree(): Boolean {
        return preferences.getData(IS_AD_FREE, false) ||
            billingManager.hasPurchased(AD_FREE_SKU)
    }

    // 购买无广告
    suspend fun purchaseAdFree(activity: Activity): Boolean {
        val result = billingManager.purchase(activity, AD_FREE_SKU)
        if (result) {
            preferences.saveData(IS_AD_FREE, true)
        }
        return result
    }

    // 无广告定价选项
    data class AdFreeOption(
        val sku: String,
        val name: String,
        val price: String,
        val duration: String,
        val description: String
    )

    fun getAdFreeOptions(): List<AdFreeOption> {
        return listOf(
            AdFreeOption(
                sku = "ad_free_monthly",
                name = "每月无广告",
                price = "$1.99",
                duration = "1个月",
                description = "去除所有广告，持续1个月"
            ),
            AdFreeOption(
                sku = "ad_free_yearly",
                name = "每年无广告",
                price = "$9.99",
                duration = "1年",
                description = "去除所有广告，持续1年，省58%"
            ),
            AdFreeOption(
                sku = AD_FREE_SKU,
                name = "终身无广告",
                price = "$29.99",
                duration = "永久",
                description = "一次性购买，终身无广告"
            )
        )
    }
}
```

---

## 七、收入预测

### 7.1 广告收入模型

```
基础假设（保守）：
├─ DAU：10,000（第1年）
├─ 广告展示频率：3次/天/用户
├─ 日广告展示：30,000
├─ 填充率：95%
├─ 有效展示：28,500
├─ 平均 eCPM：$8
└─ 月收入：28,500 × 30 × $8 / 1000 = $6,840

增长预测：

Year 1:
├─ Q1：DAU 2,000 → 月收入 $1,368
├─ Q2：DAU 5,000 → 月收入 $3,420
├─ Q3：DAU 10,000 → 月收入 $6,840
└─ Q4：DAU 15,000 → 月收入 $10,260

Year 1 总收入：$65,580

Year 2 (10倍增长)：
├─ DAU：100,000
├─ 月收入：$68,400
└─ 年收入：$820,800

Year 3 (持续增长)：
├─ DAU：300,000
├─ 月收入：$205,200
└─ 年收入：$2,462,400
```

### 7.2 各广告形式收入分布

```
收入构成（Year 1）：

Banner 广告（30%）：
├─ eCPM：$2
├─ 展示占比：70%
└─ 收入：$19,674

原生广告（50%）：
├─ eCPM：$10
├─ 展示占比：20%
└─ 收入：$32,790

激励视频（20%）：
├─ eCPM：$20
├─ 展示占比：10%
└─ 收入：$13,116
```

### 7.3 订阅 vs 广告对比

```
混合收入模型（推荐）：

免费用户（90% - 9,000 DAU）：
├─ 广告收入
├─ 付费转化 5% = 450 用户
└─ 订阅收入：$1,995/月（$4.99 × 450）

付费用户（10% - 1,000 DAU）：
├─ 无广告
└─ 订阅收入：$4,990/月（$4.99 × 1,000）

总收入：
├─ 广告：$6,156/月（90% × $6,840）
├─ 订阅：$6,985/月
└─ 月总收入：$13,141
└─ 年收入：$157,692

对比：
├─ 纯广告：$6,840/月 = $82,080/年
└─ 混合模式：$13,141/月 = $157,692/年（+92%）
```

---

## 八、合规与安全

### 8.1 Google AdMob 政策

```
必须遵守的政策：

✅ 内容政策：
├─ 不展示成人内容
├─ 不展示暴力内容
├─ 不展示危险内容
└─ 不展示歧视性内容

✅ 广告位置政策：
├─ 不遮挡广告
├─ 不鼓励误触
├─ 不在内容中插入广告
└─ 不使用诱导点击

✅ 隐私政策：
├─ 明确隐私政策
├─ 用户同意机制
├─ 数据收集声明
└─ 符合 GDPR/CCPA

违反政策后果：
├─ 警告
├─ 广告展示受限
├─ 账户暂停
└─ 收入清零
```

### 8.2 GDPR 合规

```kotlin
// GDPR 同意管理器
class ConsentManager @Inject constructor(
    private val context: Context
) {
    fun requestConsent(
        activity: Activity,
        onConsentGranted: () -> Unit,
        onConsentDenied: () -> Unit
    ) {
        val consentInformation = ConsentInformation.getInstance(context)

        // 检查是否需要请求同意
        consentInformation.requestConsentInfoUpdate(
            activity,
            ConsentRequestParameters.Builder()
                .setTagForUnderAgeOfConsent(false)
                .build(),
            object : ConsentInformation.OnConsentInfoUpdateSuccessListener {
                override fun onConsentInfoUpdate(consentStatus: ConsentStatus) {
                    when (consentStatus) {
                        ConsentStatus.OBTAINED -> onConsentGranted()
                        ConsentStatus.REQUIRED -> showConsentForm(activity, onConsentGranted, onConsentDenied)
                        ConsentStatus.NOT_REQUIRED -> onConsentGranted()
                        else -> onConsentDenied()
                    }
                }

                override fun onFailedToUpdateConsentInfo(error: String) {
                    onConsentDenied()
                }
            }
        )
    }

    private fun showConsentForm(
        activity: Activity,
        onGranted: () -> Unit,
        onDenied: () -> Unit
    ) {
        val privacyOptions = ConsentPrivacyOptions.getInstance()
        val consentForm = ConsentForm.getInstance(activity, GDPR_URL)

        consentForm.load(
            activity,
            object : ConsentForm.OnConsentFormLoadedListener {
                override fun onConsentFormLoaded() {
                    consentForm.show(
                        activity,
                        object : ConsentForm.OnConsentFormDismissedListener {
                            override fun onConsentFormDismissed(
                                consentStatus: ConsentStatus,
                                userPrefersAdFree: Boolean
                            ) {
                                when (consentStatus) {
                                    ConsentStatus.OBTAINED -> onGranted()
                                    else -> onDenied()
                                }
                            }
                        }
                    )
                }

                override fun onConsentFormError(error: String) {
                    onDenied()
                }
            }
        )
    }
}
```

### 8.3 广告质量过滤

```kotlin
// 广告过滤器
class AdFilter @Inject constructor(
    private val maliciousUrlDatabase: MaliciousUrlDatabase,
    private val userReports: UserReportDatabase
) {
    // 检查广告是否安全
    suspend fun isAdSafe(adContent: String): Boolean {
        // 1. 检查是否为恶意 URL
        if (maliciousUrlDatabase.isMalicious(adContent)) {
            return false
        }

        // 2. 检查用户举报
        if (userReports.getReportCount(adContent) > 10) {
            return false
        }

        // 3. 检查关键词
        val blockedKeywords = listOf(
            "casino", "gambling", "porn", "xxx",
            "loan", "crypto", "betting"
        )
        if (blockedKeywords.any { adContent.contains(it, ignoreCase = true) }) {
            return false
        }

        return true
    }

    // 广告拦截（本地）
    fun shouldBlockAd(adUrl: String): Boolean {
        val blockedDomains = listOf(
            "malicious-site.com",
            "spam-site.com"
        )

        return blockedDomains.any { domain ->
            adUrl.contains(domain, ignoreCase = true)
        }
    }
}
```

### 8.4 儿童隐私

```kotlin
// 儿童安全模式
class ChildSafetyMode @Inject constructor(
    private val preferences: DataStore<Preferences>
) {
    // 检查是否为儿童模式
    suspend fun isChildMode(): Boolean {
        return preferences.getData(IS_CHILD_MODE, false)
    }

    // 在儿童模式下禁用广告
    fun canShowAds(): Boolean {
        // COPPA 合规
        return !isChildMode()
    }

    // 标记为儿童应用（如果需要）
    fun markAsChildDirected() {
        val requestConfiguration = RequestConfiguration.Builder()
            .setMaxAdContentRating(RequestConfiguration.MAX_AD_CONTENT_RATING_G)
            .setTagForChildDirectedTreatment(RequestConfiguration.TAG_FOR_CHILD_DIRECTED_TREATMENT_TRUE)
            .build()

        MobileAds.setRequestConfiguration(requestConfiguration)
    }
}
```

---

## 总结

### 推荐的广告策略

```
Phase 1 (MVP - 3个月)：
├─ 平台：Google AdMob
├─ 形式：
│   ├─ Banner（设置页面）- 30%
│   ├─ Native Ads（历史记录）- 50%
│   └─ Rewarded Video（增值功能）- 20%
├─ 预期 eCPM：$8-12
└─ 月收入（10K DAU）：$6,840

Phase 2 (增长期 - 6-12个月)：
├─ 平台：AdMob + Audience Network
├─ 形式：增加激励插屏
├─ 优化：A/B 测试，频率优化
├─ 预期 eCPM：$10-15
└─ 月收入（50K DAU）：$45,000

Phase 3 (成熟期 - 12个月+)：
├─ 平台：AppLovin MAX 聚合
├─ 形式：全部形式 + 瀑布流优化
├─ 优化：实时竞价，机器学习
├─ 预期 eCPM：$12-20
└─ 月收入（200K DAU）：$288,000

混合收入模型：
├─ 广告收入：60%
├─ 订阅收入：40%
└─ 总收入最大化
```

### 关键要点

1. **用户体验优先**
   - 不在核心功能中展示广告
   - 明确标识广告
   - 提供无广告选项

2. **选择合适的广告形式**
   - 原生广告（最佳体验）
   - 激励视频（最高 eCPM）
   - Banner（稳定基础）

3. **持续优化**
   - A/B 测试
   - 频率控制
   - 收益分析

4. **遵守政策**
   - AdMob 政策
   - GDPR 合规
   - 儿童隐私保护

### 下一步行动

1. ✅ 注册 AdMob 账户
2. ✅ 集成 AdMob SDK
3. ✅ 实现基础广告形式（Banner + Native）
4. ✅ 添加激励视频（增值功能）
5. ✅ 配置频率控制
6. ✅ 设置 GDPR 同意
7. ✅ 测试广告加载
8. ✅ 发布并监控收益

---

**祝你成功！** 📱💰
