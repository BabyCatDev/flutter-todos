import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/i10n/localization_intl.dart';
import 'package:todo_list/json/task_icon_bean.dart';
import 'package:todo_list/model/icon_setting_page_model.dart';
import 'package:todo_list/widgets/custom_animated_icon.dart';
import 'package:todo_list/widgets/custom_animated_switcher.dart';

class IconSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<IconSettingPageModel>(context);
    model.setContext(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(DemoLocalizations.of(context).iconSetting),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(DemoLocalizations.of(context).currentIcons),
                  margin: EdgeInsets.only(top: 20, left: 25),
                  alignment: Alignment.centerLeft,
                ),
              ),
              Expanded(
                child: Container(
                  child: CustomAnimatedSwitcher(
                    firstChild: Icon(
                      Icons.border_color,
                      size: 20,
                    ),
                    secondChild: Icon(
                      Icons.check,
                      size: 20,
                      color: Colors.greenAccent,
                    ),
                    hasChanged: model.isDeleting,
                    onTap: (){
                      model.isDeleting = !model.isDeleting;
                      model.refresh();
                    },
                  ),
                  margin: EdgeInsets.only(top: 20, right: 25),
                  alignment: Alignment.centerRight,
                ),
              ),
            ],
          ),
          Container(
            height: 150,
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: GridView.count(
              crossAxisCount: 2,
              scrollDirection: Axis.horizontal,
              children: List.generate(
                model.taskIcons.length,
                (index) {
                  final taskIcon = model.taskIcons[index];
                  return Stack(
                    children: <Widget>[
                      AbsorbPointer(
                        absorbing: model.isDeleting ? true : false,
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                  child: Icon(
                                    IconBean.fromBean(taskIcon.iconBean),
                                    color:
                                        ColorBean.fromBean(taskIcon.colorBean),
                                    size: 40,
                                  ),
                                  onTap: () {
                                    model.logic.tapDefaultIcon(index);
                                    if (index <= 5) return;
                                    model.logic.onIconPress(
                                      model.taskIcons[index].iconBean,
                                      colorBean:
                                          model.taskIcons[index].colorBean,
                                      name: model.taskIcons[index].taskName,
                                      index: index,
                                      isEdit: true,
                                    );
                                  }),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                taskIcon.taskName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: AbsorbPointer(
                          absorbing: model.isDeleting ? false : true,
                          child: Opacity(
                            opacity:
                                (index > 5 && model.isDeleting) ? 1.0 : 0.0,
                            child: GestureDetector(
                              onTap: () => model.logic.removeIcon(index),
                              child: Icon(
                                Icons.cancel,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: FutureBuilder(
                  future: IconBean.loadAsset(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      );
                    }
                    List<IconBean> icons = snapshot.data;
                    return GridView.count(
                      crossAxisCount: 5,
                      childAspectRatio: 0.8,
                      padding: EdgeInsets.all(2),
                      children: List.generate(icons.length, (index) {
                        final icon = icons[index];
                        return Container(
                          margin: EdgeInsets.all(4),
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                onPressed: () => model.logic.onIconPress(icon),
                                icon: Icon(
                                  IconBean.fromBean(icon),
                                  size: 30,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Expanded(
                                child: Text(
                                  icons[index].iconName,
                                  style: TextStyle(fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  }),
            ),
          )
        ],
      )),
    );
  }
}
