import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final String Function(T) itemAsString;
  final Function(T) onChanged;
  final String hintText;
  final VoidCallback? onAddPressed; // دالة زر الإضافة

  const CustomDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    required this.itemAsString,
    required this.onChanged,
    this.hintText = "اختر", // نص افتراضي
    this.onAddPressed,
  });

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  GlobalKey actionKey = GlobalKey();
  double height = 0, width = 0, xPosition = 0, yPosition = 0;
  bool isDropdownOpened = false;
  OverlayEntry? floatingDropdown;

  @override
  void initState() {
    super.initState();
  }

  // [FIX 1] - تمت إضافة دالة dispose
  @override
  void dispose() {
    // التأكد من إزالة القائمة المنسدلة عند إغلاق الصفحة أو التنقل
    closeDropdown();
    super.dispose();
  }

  // دالة لإغلاق القائمة
  void closeDropdown() {
    // التأكد من أننا لا نحاول إغلاق قائمة مغلقة أصلاً
    if (!isDropdownOpened || floatingDropdown == null) return;

    if (floatingDropdown!.mounted) {
      floatingDropdown!.remove();
    }
    floatingDropdown = null; // تنظيف المتغير
    setState(() {
      isDropdownOpened = false;
    });
  }

  void findDropdownData() {
    RenderBox? renderBox =
        actionKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      height = renderBox.size.height;
      width = renderBox.size.width;
      Offset offset = renderBox.localToGlobal(Offset.zero);
      xPosition = offset.dx;
      yPosition = offset.dy;
    }
  }

  // [FIX 2] - تم تعديل هذه الدالة بالكامل
  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      // استخدام Stack للسماح بالنقر في الخارج
      return Stack(
        children: [
          // 1. طبقة شفافة تملأ الشاشة بالكامل لاكتشاف النقر "في الخارج"
          Positioned.fill(
            child: GestureDetector(
              onTap: closeDropdown, // عند النقر هنا، أغلق القائمة

              // [FIX] - تمت إضافة هذا السطر
              // سيتم إغلاق القائمة بمجرد بدء السحب (Drag)
              onPanDown: (_) => closeDropdown(),

              behavior: HitTestBehavior
                  .translucent, // لضمان التقاط النقر على المساحات الشفافة
              child: Container(color: Colors.transparent),
            ),
          ),
          // 2. القائمة المنسدلة الفعلية، موضوعة في مكانها الصحيح
          Positioned(
            left: xPosition,
            width: width,
            top: yPosition + height,
            child: DropDown<T>(
              itemHeight: height,
              items: widget.items,
              selectedItem: widget.selectedItem,
              itemAsString: widget.itemAsString,
              onChanged: widget.onChanged,
              onAddPressed: widget.onAddPressed,
              onOverlayRemove: closeDropdown, // تمرير دالة الإغلاق
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: actionKey,
      onTap: () {
        setState(() {
          if (isDropdownOpened) {
            closeDropdown(); // استخدام الدالة المخصصة للإغلاق
          } else {
            findDropdownData();
            floatingDropdown = _createFloatingDropdown();
            Overlay.of(context).insert(floatingDropdown!);
            isDropdownOpened = true;
          }
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                // استخدام Expanded لمنع تجاوز النص
                child: Text(
                  // عرض العنصر المختار أو الـ Hint
                  (widget.selectedItem != null
                          ? widget.itemAsString(widget.selectedItem as T)
                          : widget.hintText)
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // const Spacer(), // لم نعد بحاجة لـ Spacer
              const Icon(
                Icons.arrow_drop_down,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropDown<T> extends StatelessWidget {
  final double itemHeight;
  final List<T> items; // قائمة العناصر الديناميكية
  final T? selectedItem; // العنصر المختار حالياً
  final String Function(T) itemAsString; // دالة لتحويل العنصر إلى نص
  final Function(T) onChanged; // دالة تُستدعى عند الاختيار
  final VoidCallback onOverlayRemove; // دالة لإغلاق الـ Overlay
  final VoidCallback? onAddPressed; // دالة لزر الإضافة (اختياري)

  const DropDown({
    Key? key,
    required this.itemHeight,
    required this.items,
    this.selectedItem,
    required this.itemAsString,
    required this.onChanged,
    required this.onOverlayRemove,
    this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // بناء قائمة العناصر
    List<Widget> children = [];

    // 1. إضافة زر "إضافة جديد" إذا كان موجوداً
    if (onAddPressed != null) {
      children.add(
        DropDownItem(
          text: "إضافة جديد",
          iconData: Icons.add_circle_outline,
          isSelected: false,
          isFirstItem: true, // هو العنصر الأول
          isLastItem: items.isEmpty, // هو الأخير إذا كانت القائمة فارغة
          onTap: () {
            onAddPressed!();
            onOverlayRemove(); // إغلاق القائمة بعد الضغط
          },
        ),
      );
    }

    // 2. إضافة عناصر القائمة الديناميكية
    children.addAll(
      items.asMap().entries.map((entry) {
        int index = entry.key;
        T item = entry.value;
        bool isFirst = (onAddPressed == null && index == 0);
        bool isLast = (index == items.length - 1);
        bool isSelected = (item == selectedItem);

        return DropDownItem(
          text: itemAsString(item), // استخدام الدالة لعرض النص
          isSelected: isSelected,
          isFirstItem: isFirst,
          isLastItem: isLast,
          onTap: () {
            onChanged(item); // إرجاع العنصر المختار
            onOverlayRemove(); // إغلاق القائمة
          },
        );
      }),
    );

    // إذا لم يكن هناك عناصر ولا زر إضافة، أضف عنصر "فارغ"
    if (children.isEmpty) {
      children.add(
        DropDownItem(
          text: "لا توجد بيانات",
          isSelected: false,
          isFirstItem: true,
          isLastItem: true,
          onTap: onOverlayRemove, // إغلاق القائمة فقط
        ),
      );
    }

    return Column(
      children: <Widget>[
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: const Alignment(-0.85, 0),
          child: ClipPath(
            clipper: ArrowClipper(), // (هذا صحيح للسهم)
            child: Container(
              height: 20,
              width: 30,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        Material(
          elevation: 20,
          shape: RoundedRectangleBorder(
            // <--- هذا هو التصحيح
            borderRadius: BorderRadius.circular(8),
          ),
          // [FIX] - تم تعديل هذا الجزء بالكامل لحل مشكلة الارتفاع
          child: Container(
            // الإبقاء على الكونتينر للديكور
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // تم تعديل هذا اللون ليستخدم لون الـ Card
              color: Theme.of(context).cardColor,
            ),
            // استخدام ConstrainedBox لتحديد أقصى ارتفاع
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: itemHeight * 5, // حد أقصى 5 عناصر
              ),
              child: ListView(
                shrinkWrap: true, // <--- هذا هو السطر الأهم
                padding: EdgeInsets.zero,
                children: children,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DropDownItem extends StatelessWidget {
  final String text;
  final IconData? iconData; // أصبح اختيارياً
  final bool isSelected;
  final bool isFirstItem;
  final bool isLastItem;
  final VoidCallback? onTap; // تمت إضافة هذا

  const DropDownItem({
    Key? key,
    required this.text,
    this.iconData,
    this.isSelected = false,
    this.isFirstItem = false,
    this.isLastItem = false,
    this.onTap, // تمت إضافة هذا
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      // استخدمنا InkWell لجعل العنصر قابلاً للنقر
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: isFirstItem ? const Radius.circular(8) : Radius.zero,
            bottom: isLastItem ? const Radius.circular(8) : Radius.zero,
          ),
          color: isSelected
              ? theme.primaryColor // لون خفيف عند الاختيار
              : theme.cardTheme.color, // لون البطاقة العادي
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            Text(
              text.toUpperCase(), // يمكنك إزالة .toUpperCase() إذا أردت
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (iconData != null) // نعرض الأيقونة فقط إذا وُجدت
              Icon(
                iconData,
                color: theme.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}

/// Clipper بسيط يرسم سهماً (مثل مثلث مع قمة في الوسط)
class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

/// ShapeBorder مخصص يرسم نفس شكل السهم.
class ArrowShape extends ShapeBorder {
  const ArrowShape();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _buildArrowPath(rect.size);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => const ArrowShape();

  Path _buildArrowPath(Size size) {
    final Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }
}
