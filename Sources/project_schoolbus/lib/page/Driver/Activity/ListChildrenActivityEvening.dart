import 'package:flutter/cupertino.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:project_schoolbus/model/ActivityModel.dart';

import '../../../importer.dart';
import '../../../manager/ActivityManager.dart';
import '../../../manager/ContractManager.dart';
import '../../../manager/DriverManager.dart';
import '../../../model/ContractModel.dart';
import '../../AlertDialog.dart';
import '../../MainPage/mainDriver.dart';
import 'ActivityPage.dart';
class ListChildrenActivityEvening extends StatefulWidget {
  const ListChildrenActivityEvening({Key? key}) : super(key: key);

  @override
  State<ListChildrenActivityEvening> createState() => _ListChildrenActivityEveningState();
}
enum SingingCharacter { lafayette, jefferson }

class _ListChildrenActivityEveningState extends State<ListChildrenActivityEvening> {
  final _ctrlreason = TextEditingController();
  ContractManager manager = ContractManager();
  ActivityManager amanager = ActivityManager();
  DriverManager dmanager = DriverManager();
  List<Contract>? listChildren;
  bool isLoading = true;
  String num_plate = getSharedPreferences.getNum_plate() ?? '';
  String b = getSharedPreferences.getBus() ?? '';
  Bus? bus;
  String? reason;
  bool status = true;
  List<Activity>? listActivityis1;
  SingingCharacter? _character = SingingCharacter.lafayette;

  @override
  void initState() {
    getlistActivityis1();
    refreshChildren();
    getProfile();
    super.initState();
  }
  void getProfile(){
    Map<String, dynamic> map2 = jsonDecode(b);
    bus = Bus.fromJson(map2);
  }
  void refreshChildren() async {
    setState(() {
      isLoading = true;
    });
    manager.driver_listChildren2(num_plate).then((value) async => {
      setState(() {
        listChildren = value;
        isLoading = false;
      }),
    });
  }

  void getlistActivityis1() {
    setState(() {
      isLoading = true;
    });
    amanager.listActivitytime2().then((value)  async => {
      setState(() {
        listActivityis1 = value;
        isLoading = false;
      }),
    });
  }


  Position? _position;
  Future _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
  AlertDialogApp alertDialogApp =AlertDialogApp();


  String? childrenStatus;

  @override
  Widget build(BuildContext context)  {
    if(isLoading){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      alignment: Alignment.center,

      child: (listChildren == null || listChildren!.isEmpty) ? const Text("ไม่มีรายการเด็ก") :  buildListChildren(),
    );
  }


  Widget buildListChildren() {
    return Align(
      alignment: Alignment.topCenter,
      child:  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Row(
              children: const [
                SizedBox(width: 5,),
                Icon(
                  CupertinoIcons.list_bullet,
                  size: 30.0,
                ),
                SizedBox(width: 10,),
                Text('รายการสัญญา :',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800),),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listChildren!.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height*0.265,
                    width:  MediaQuery.of(context).size.width*1,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: Image.network(
                                    listChildren![index].children.image_profile,
                                    width: 120.0,
                                    height: 120.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 40,
                                        children: [
                                          Column(
                                            crossAxisAlignment : CrossAxisAlignment.start,
                                            mainAxisAlignment : MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(
                                                'ชื่อ',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              const SizedBox(height: 5.0,),
                                              Text(
                                                listChildren![index].children.firstname,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment : CrossAxisAlignment.start,
                                            mainAxisAlignment : MainAxisAlignment.spaceAround,
                                            children: [
                                              const Text(
                                                'นามสกุล',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              const SizedBox(height: 5.0,),
                                              Text(
                                                listChildren![index].children.lastname,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment : CrossAxisAlignment.start,
                                            mainAxisAlignment : MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(
                                                'อายุ',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              const SizedBox(height: 6.0,),
                                              Text(
                                                CalAge(listChildren![index].children.birthday),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment : CrossAxisAlignment.start,
                                        mainAxisAlignment : MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            'โรงเรียน',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 5.0,),
                                          Text(
                                            listChildren![index].busStop.school.school_name,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            ckinlist1(listChildren![index]) ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await _getCurrentLocation();
                                      DateTime d =DateTime.now();
                                      Activity activity = Activity("",_position!.latitude.toString(),_position!.longitude.toString(),DateFormat('yyyy-MM-dd HH:mm:ss').format(d)
                                          ,"","","1900-01-01 00:00:00","",2,1,listChildren![index]);
                                      doaddActivity(context,activity);

                                    },
                                    child: const Text('ขึ้น'),
                                    style: ButtonStyle(
                                      textStyle: MaterialStateProperty.all(
                                        const TextStyle(fontFamily: 'Kanit',fontWeight: FontWeight.w600),
                                      ),
                                      backgroundColor: MaterialStateProperty.all(Color(0xffa3d064)),
                                      shadowColor: MaterialStateProperty.all(Colors.black12),
                                      minimumSize: MaterialStateProperty.all(const Size(150, 40)),
                                      padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 10, 20, 10)),
                                      foregroundColor: MaterialStateProperty.all(Colors.white),
                                    ),
                                  ),
                                ) ,
                                const SizedBox(
                                  width: 20,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog<String>(context: context, builder: (BuildContext context) => Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Stack(
                                            overflow: Overflow.visible,
                                            alignment: Alignment.topCenter,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(10) ,
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 10,
                                                ),
                                                child: SafeArea(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: const [
                                                          Icon(Icons.report,size: 25,),

                                                          Text(
                                                            'ใส่เหตุผลที่ไม่ขึ้นรถ',
                                                            style: TextStyle(
                                                              color: Colors.black87,
                                                              fontSize: 16.0,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [

                                                          Divider(),

                                                          RadioListTile(
                                                            title: Text("ไม่สบาย"),
                                                            value: "ไม่สบาย",
                                                            groupValue: reason,
                                                            onChanged: (value){
                                                              setState(() {
                                                                reason = value.toString();
                                                              });
                                                            },
                                                          ),

                                                          RadioListTile(
                                                            title: Text("ผู้ปกครองไปส่ง"),
                                                            value: "ผู้ปกครองไปส่ง",
                                                            groupValue: reason,
                                                            onChanged: (value){
                                                              setState(() {
                                                                reason = value.toString();
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: const [
                                                          Icon(Icons.report,size: 25,),

                                                          Text(
                                                            'ตอนเย็นให้ไปรับไหม',
                                                            style: TextStyle(
                                                              color: Colors.black87,
                                                              fontSize: 16.0,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      RadioListTile(
                                                        title: Text("ขึ้น"),
                                                        value: "ขึ้น",
                                                        groupValue: childrenStatus,
                                                        onChanged: (value){
                                                          setState(() {
                                                            childrenStatus = value.toString();
                                                          });
                                                        },
                                                      ),
                                                      RadioListTile(
                                                        title: Text("ไม่ขึ้น"),
                                                        value: "ไม่ขึ้น",
                                                        groupValue: childrenStatus,
                                                        onChanged: (value){
                                                          setState(() {
                                                            childrenStatus = value.toString();
                                                          });
                                                        },
                                                      ),

                                                      Divider(),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),);
                                    },
                                    child: const Text('ไม่ขึ้น' ),
                                    style: ButtonStyle(
                                      textStyle: MaterialStateProperty.all(
                                        const TextStyle(fontFamily: 'Kanit',fontWeight: FontWeight.w600,),
                                      ),
                                      foregroundColor: MaterialStateProperty.all(Colors.white),
                                      backgroundColor: MaterialStateProperty.all(Color(0xffed4145)),
                                      shadowColor: MaterialStateProperty.all(Colors.black12),
                                      minimumSize: MaterialStateProperty.all(const Size(150, 40)),
                                      padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 10, 20, 10)),

                                    ),
                                  ),
                                )
                              ],
                            ):Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _getCurrentLocation();
                                  DateTime d =DateTime.now();
                                  Activity activity = getactivity(listChildren![index]);
                                  setState(() {
                                    activity.get_off_latitude  = _position!.latitude.toString();
                                    activity.get_off_longitude = _position!.longitude.toString();
                                    activity.get_off_time = DateFormat('yyyy-MM-dd HH:mm:ss').format(d);
                                    activity.status_children =2;
                                  });
                                  doupdateActivity(context,activity);

                                },
                                child: const Text('ลง'),
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                    const TextStyle(fontFamily: 'Kanit',fontWeight: FontWeight.w600),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(Color(0xffa3d064)),
                                  shadowColor: MaterialStateProperty.all(Colors.black12),
                                  minimumSize: MaterialStateProperty.all(const Size(150, 40)),
                                  padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 10, 20, 10)),
                                  foregroundColor: MaterialStateProperty.all(Colors.white),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ) ,

                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    )
      ;
  }



  Future doaddActivity(BuildContext context,Activity activity) async {
    try{
      String result = await amanager.doAddActivity(activity);
      var logger = Logger();
      await getSharedPreferences.init();
      logger.e(result);
      if(result != "0") {
        _getCurrentLocation();
        getlistActivityis1();
        refreshChildren();
        bus!.bus_latitude =_position!.latitude.toString();
        bus!.bus_longitude =_position!.longitude.toString();
        String results = await dmanager.updateBuslocation(bus!);
        if(results != "0") {
          AnimatedSnackBar.rectangle(
              'สำเร็จ',
              'คุณเพิ่มกิจกรรมสำเร็จ',
              type: AnimatedSnackBarType.success,
              brightness: Brightness.light,
              duration : const Duration(seconds: 5)
          ).show(
            context,
          );
        }else{
          AnimatedSnackBar.rectangle(
              'เกิดข้อผิดพลาด',
              'เกิดข้อผิดพลาดในการเพิ่มกิจกรรมสำเร็จ',
              type: AnimatedSnackBarType.error,
              brightness: Brightness.light,
              duration : const Duration(seconds: 5)
          ).show(
            context,
          );
          isLoading = false;
        }
      }else{
        AnimatedSnackBar.rectangle(
            'เกิดข้อผิดพลาด',
            'เกิดข้อผิดพลาดในการเพิ่มกิจกรรมสำเร็จ',
            type: AnimatedSnackBarType.error,
            brightness: Brightness.light,
            duration : const Duration(seconds: 5)
        ).show(
          context,
        );
        isLoading = false;

      }
    }catch(error){
      print(error);
    }
  }

  Future doupdateActivity(BuildContext context,Activity activity) async {
    try{
      String result = await amanager.editActivity(activity);
      var logger = Logger();
      await getSharedPreferences.init();
      logger.e(result);
      if(result != "0") {
        _getCurrentLocation();
        getlistActivityis1();
        refreshChildren();
        bus!.bus_latitude =_position!.latitude.toString();
        bus!.bus_longitude =_position!.longitude.toString();
        String results = await dmanager.updateBuslocation(bus!);
        if(results != "0") {
          AnimatedSnackBar.rectangle(
              'สำเร็จ',
              'คุณเพิ่มกิจกรรมสำเร็จ',
              type: AnimatedSnackBarType.success,
              brightness: Brightness.light,
              duration : const Duration(seconds: 5)
          ).show(
            context,
          );
        }else{
          AnimatedSnackBar.rectangle(
              'เกิดข้อผิดพลาด',
              'เกิดข้อผิดพลาดในการเพิ่มกิจกรรมสำเร็จ',
              type: AnimatedSnackBarType.error,
              brightness: Brightness.light,
              duration : const Duration(seconds: 5)
          ).show(
            context,
          );
          isLoading = false;
        }
      }else{
        AnimatedSnackBar.rectangle(
            'เกิดข้อผิดพลาด',
            'เกิดข้อผิดพลาดในการแก้ไขกิจกรรมสำเร็จ',
            type: AnimatedSnackBarType.error,
            brightness: Brightness.light,
            duration : const Duration(seconds: 5)
        ).show(
          context,
        );
        isLoading = false;
      }
    }catch(error){
      print(error);
    }
  }

  String CalAge(DateTime date){
    DateTime purchase_date = DateTime(date.year, date.month, date.day);
    DateDuration duration;
    duration = AgeCalculator.age(purchase_date);
    return duration.years.toString();
  }

  Activity getactivity(Contract c){
    Activity? activity ;
    for(Activity a in listActivityis1!){
      if(a.contract.contract_ID == c.contract_ID){
        activity = a;
        break;
      }
    }
    return activity!;
  }

  bool ckinlist1(Contract c){
    bool r = true;
    if(listActivityis1 != null){
      for(Activity a in listActivityis1!){
        if(a.contract.contract_ID == c.contract_ID){
          r = false;
        }
      }
    }
    return r;
  }
}

