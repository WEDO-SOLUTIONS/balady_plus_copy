import 'package:flutter/material.dart';

/// 4-step TIFO tutorial. Figma nodes 1:8639 / 1:8845 / 1:9051 / 1:9261.
///
/// Modal sheet shown on the player's first ⚽ tap after team selection. Each
/// step has a topic (Arabic + English), Arabic + English description, and a
/// preview card. Navigation: back arrow → previous step, big primary CTA →
/// next step (or "Start Playing" on step 4 → dismiss). "Skip Tutorial" link
/// at the very bottom dismisses immediately on any step.
///
/// Caller is responsible for marking [TifoFlowController.markTutorialSeen]
/// once this route returns (push().then).
class TifoTutorial extends StatefulWidget {
  const TifoTutorial({super.key});

  static const _bg = Color(0xFF0A0A0A);
  static const _sheetBg = Colors.white;
  static const _textPrimary = Color(0xFF101828);
  static const _textSecondary = Color(0xFF6A7282);
  static const _textMuted = Color(0xFF9CA3AF);
  static const _accent = Color(0xFF16A34A);
  static const _accentLight = Color(0xFF22C55E);
  static const _divider = Color(0xFFE5E7EB);
  static const _previewBg = Color(0xFFF3F4F6);

  static const List<_StepData> _steps = [
    _StepData(
      icon: Icons.home_work_outlined,
      emoji: '🏘',
      topicEn: 'Districts',
      topicAr: 'الأحياء',
      descAr: 'سيطر على أحياء مدينتك ووسّع نفوذ فريقك في جميع أرجاء المدينة.',
      descEn: "Control your city's neighborhoods and expand your team's influence across the entire city.",
    ),
    _StepData(
      icon: Icons.stadium_outlined,
      emoji: '🏟',
      topicEn: 'Stadiums',
      topicAr: 'الملاعب',
      descAr: 'احتل الملاعب الكبرى لكسب نقاط استراتيجية وتعزيز مكانتك.',
      descEn: 'Capture key stadiums to earn strategic points and strengthen your position.',
    ),
    _StepData(
      icon: Icons.gps_fixed,
      emoji: '🎯',
      topicEn: 'Capture Mechanics',
      topicAr: 'آليات الاستحواذ',
      descAr: 'زر المواقع على الخريطة وأكمل التحديات للاستحواذ على الأحياء.',
      descEn: 'Visit locations on the map and complete challenges to capture districts.',
    ),
    _StepData(
      icon: Icons.diamond_outlined,
      emoji: '💎',
      topicEn: 'Rewards',
      topicAr: 'المكافآت',
      descAr: 'اكسب رموزاً حصرية وتسلق التصنيفات كلما توسّعت في اللعبة.',
      descEn: 'Earn exclusive tokens and climb the rankings as you grow in the game.',
    ),
  ];

  @override
  State<TifoTutorial> createState() => _TifoTutorialState();
}

class _TifoTutorialState extends State<TifoTutorial> {
  final PageController _controller = PageController();
  int _page = 0;

  bool get _isLast => _page == TifoTutorial._steps.length - 1;
  bool get _isFirst => _page == 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_isLast) {
      await Navigator.of(context).maybePop();
      return;
    }
    await _controller.animateToPage(
      _page + 1,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _prev() async {
    if (_isFirst) return;
    await _controller.animateToPage(
      _page - 1,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sheetHeight = (mq.size.height * 0.62).clamp(480.0, 620.0).toDouble();

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.55),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                height: sheetHeight,
                decoration: const BoxDecoration(
                  color: TifoTutorial._sheetBg,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    _Dragger(),
                    _Header(onClose: () => Navigator.of(context).maybePop()),
                    _ProgressDots(
                      total: TifoTutorial._steps.length,
                      active: _page,
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,
                        onPageChanged: (i) => setState(() => _page = i),
                        itemCount: TifoTutorial._steps.length,
                        itemBuilder: (context, i) {
                          return _StepBody(step: TifoTutorial._steps[i]);
                        },
                      ),
                    ),
                    _BottomBar(
                      isFirst: _isFirst,
                      isLast: _isLast,
                      onPrev: _prev,
                      onNext: _next,
                      onSkip: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pieces ───────────────────────────────────────────────────────────────────

class _Dragger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: TifoTutorial._divider,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 8, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'كيف تلعب · How to Play',
                  style: TextStyle(
                    fontSize: 11,
                    height: 15 / 11,
                    color: TifoTutorial._textSecondary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'TIFO TUTORIAL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    height: 28 / 20,
                    letterSpacing: 0.4,
                    color: TifoTutorial._textPrimary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: TifoTutorial._textSecondary),
            visualDensity: VisualDensity.compact,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.total, required this.active});

  final int total;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < total; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == active ? 24 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == active ? TifoTutorial._accent : TifoTutorial._divider,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
        ],
      ),
    );
  }
}

class _StepBody extends StatelessWidget {
  const _StepBody({required this.step});

  final _StepData step;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview card.
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: TifoTutorial._previewBg,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              step.emoji,
              style: const TextStyle(fontSize: 64, height: 1.0),
            ),
          ),
          const SizedBox(height: 20),
          // Topic row (icon + En topic + Ar topic).
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: TifoTutorial._previewBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  step.icon,
                  size: 18,
                  color: TifoTutorial._textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.topicEn,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 16 / 12,
                        color: TifoTutorial._textSecondary,
                      ),
                    ),
                    Text(
                      step.topicAr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        height: 23 / 17,
                        color: TifoTutorial._textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Arabic description.
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              step.descAr,
              style: const TextStyle(
                fontSize: 14,
                height: 22 / 14,
                color: TifoTutorial._textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // English description.
          Text(
            step.descEn,
            style: const TextStyle(
              fontSize: 13,
              height: 20 / 13,
              color: TifoTutorial._textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.isFirst,
    required this.isLast,
    required this.onPrev,
    required this.onNext,
    required this.onSkip,
  });

  final bool isFirst;
  final bool isLast;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _CircleArrow(
                icon: Icons.arrow_back,
                enabled: !isFirst,
                onTap: onPrev,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onNext,
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          TifoTutorial._accent,
                          TifoTutorial._accentLight,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: TifoTutorial._accent.withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLast ? 'Start Playing' : 'التالي · Next',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            height: 22 / 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isLast ? Icons.play_arrow : Icons.arrow_forward,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onSkip,
            child: const Text(
              'تخطي الشرح · Skip Tutorial',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                height: 18 / 13,
                color: TifoTutorial._textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleArrow extends StatelessWidget {
  const _CircleArrow({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: enabled ? TifoTutorial._previewBg : const Color(0xFFF9FAFB),
          border: Border.all(color: TifoTutorial._divider),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: enabled ? TifoTutorial._textPrimary : TifoTutorial._textMuted,
        ),
      ),
    );
  }
}

// ─── Data ────────────────────────────────────────────────────────────────────

class _StepData {
  const _StepData({
    required this.icon,
    required this.emoji,
    required this.topicEn,
    required this.topicAr,
    required this.descAr,
    required this.descEn,
  });

  final IconData icon;
  final String emoji;
  final String topicEn;
  final String topicAr;
  final String descAr;
  final String descEn;
}
