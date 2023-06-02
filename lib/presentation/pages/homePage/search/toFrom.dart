import 'package:flutter/material.dart';

import '/presentation/resources/color_manager.dart';
import '/presentation/resources/routes_manager.dart';

class ToFrom extends StatefulWidget {
  @override
  State<ToFrom> createState() => _ToFromState();
}

class _ToFromState extends State<ToFrom> {
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();

    @override
    void initState() {
      super.initState();

      controller1.addListener(() {
        setState(() {});
      });
      controller2.addListener(() {
        setState(() {});
      });
    }
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    TextField t1 = TextField(
      controller: controller1,
      style: TextStyle(color: ColorManager.appBlack),
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        hintText: 'Choose start location',
        suffixIcon: controller1.text.isEmpty
            ? Container(width: 0)
            : IconButton(
                onPressed: () => controller1.clear(),
                icon: Icon(
                  Icons.close,
                ),
              ),
        border: OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.done,
    );
    TextField t2 = TextField(
      controller: controller2,
      style: TextStyle(color: ColorManager.appBlack),
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        hintText: 'Choose destination',
        suffixIcon: controller2.text.isEmpty
            ? Container(width: 0)
            : IconButton(
                onPressed: () => controller2.clear(),
                icon: Icon(
                  Icons.close,
                ),
              ),
        border: OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.done,
    );

    void _swap() {
      String tempController = controller1.text;
      controller1.text = controller2.text;
      controller2.text = tempController;
      setState(() {});
    }

    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: constraints.maxWidth * 0.15,
              child: IconButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, Routes.mainRoute),
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
                color: ColorManager.appBlack,
              ),
            ),
            if (mq.orientation == Orientation.portrait)
              Row(
                children: [
                  Container(
                    width: constraints.maxWidth * 0.10, //1
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle_outlined,
                            color: Colors.black, size: 20),
                        Icon(
                          Icons.more_vert,
                          size: 34,
                          color: Colors.grey,
                        ),
                        Icon(
                          Icons.location_on_outlined,
                          color: ColorManager.error,
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: constraints.maxWidth * 0.59, //2
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          t1,
                          SizedBox(
                            height: constraints.maxHeight * 0.08,
                          ),
                          t2,
                        ],
                      )),
                  SizedBox(
                    width: constraints.maxWidth * 0.01,
                  ),
                  Container(
                    width: constraints.maxWidth * 0.15,
                    child: Center(
                      child: IconButton(
                        onPressed: () => _swap(),
                        icon: Icon(
                          Icons.swap_vert,
                          size: 33,
                        ),
                        color: ColorManager.appBlack,
                      ),
                    ),
                  )
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: constraints.maxWidth * 0.35,
                    child: t1,
                  ),
                  Container(
                    width: constraints.maxWidth * 0.1,
                    child: Center(
                      child: Icon(
                        Icons.swap_horiz,
                        color: ColorManager.appBlack,
                        size: 33,
                      ),
                    ),
                  ),
                  Container(
                    width: constraints.maxWidth * 0.35,
                    child: t2,
                  ),
                  SizedBox(width: constraints.maxWidth * 0.04),
                ],
              )
          ],
        );
      },
    );
  }
}
