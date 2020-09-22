import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import '../data_provider/api_service.dart';
import 'package:dio/dio.dart';
import 'package:baniadam/widgets/base_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



class EmployeeInfoDialog extends StatefulWidget {
  final data;

  EmployeeInfoDialog({
    this.data,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EmployeeInfoDialogState();
  }
}

class _EmployeeInfoDialogState extends BaseState<EmployeeInfoDialog> {
  String _path;
  FileType _pickingType;
  String _extension;
  String _fileName;
  var _imagePaths;
  bool updateImage = false;
  int userType;
  String baseCdnUrl;

  @override
  void initState() {
    getCDN();
    _getUserType();
    super.initState();
  }

  getCDN()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var portalID = prefs.getString('curr-cid');
    if(portalID != null){
      setState(() {
        baseCdnUrl = ApiService.CDN_URl+"$portalID/";
      });

    }
  }

  _getUserType() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var type = prefs.getInt('user-type');
      setState(() {
        userType = type;
      });
  }


  updateEmployeePic(FormData formData) async {
    final Map<String, dynamic> successinformation =
    await ApiService.updateEmployeeInfo(formData);

    if(successinformation == null){
      Toast.show("Please make sure you provided all data properly.Maximum image size for photo attachment is 100KB", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);

    }
    else if (successinformation['success']) {
      Toast.show(successinformation['message'], context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      String photoUrl;
      final Map<String, dynamic> detailData =
      await ApiService.getEmployeeDetail();
      if (detailData != null) {
        setState(() {
          photoUrl = detailData['photoAttachment'];
        });
      }
      Navigator.of(context, rootNavigator: true).pop(photoUrl);
//      Toast.show(successinformation['message'], context,
//          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//      Navigator.of(context, rootNavigator: true).pop('success');
    } else {
      Toast.show(successinformation['message'], context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

  File galleryFile;

  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      // maxHeight: 50.0,
      // maxWidth: 50.0,
    );if(galleryFile != null){
      setState(() {
        _fileName = galleryFile.path;
        _imagePaths = galleryFile.path;
        updateImage = true;
      });
    }
    print("image from picker : " + galleryFile.path);
    setState(() {});
  }

  void _getSelectedFile() async {
    String filePath =
    await _openFileExplorer();
    if (filePath != null) {
      setState(() {
        _fileName = filePath;
        _imagePaths = filePath;
        // _path = filePath;
      });
//      print("image from file-explorer: " + _fileName);

    }
  }

  _openFileExplorer() async {
    if (_pickingType == FileType.IMAGE) {
      try {
        _path = await FilePicker.getFilePath(
            type: _pickingType, fileExtension: _extension);
        setState(() {
          _imagePaths = _path;
          _fileName = _path;
          updateImage = true;
        });
        // }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
    }

    if (!mounted) return;
    print("image from file-explorer: " + _fileName);
  }

  Widget displaySelectedFile(File file) {
    return new SizedBox(
        height: 200.0,
        width: 300.0,
        child: file == null
            ? Center(
          child: Container(
              padding: const EdgeInsets.only(left: 0.0),
              height: 180.0,
              width: 250.0,
              child: Material(
                borderRadius: BorderRadius.circular(5.0),
                child: widget.data['photoAttachment'] != null &&
                    widget.data['photoAttachment'] != "''"
//                                ?Text(data['photoAttachment']):Text('null')
//                    ? Image.network('http://testcdn.ideaxen.net/test/' + widget.data['photoAttachment'])
                    ? Image.network(baseCdnUrl + widget.data['photoAttachment'])
                    : Image.asset('assets/profile.png'),
              )),
        )
            : Image.file(file),);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        contentPadding: EdgeInsets.all(25.0),
        title: Center(child: Text('Personal information')),
        content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    displaySelectedFile(galleryFile),
//                    Center(
//                      child: Container(
//                          padding: const EdgeInsets.only(left: 0.0),
//                          height: 120.0,
//                          width: 130.0,
//                          child: Material(
//                            borderRadius: BorderRadius.circular(5.0),
//                            child: widget.data['photoAttachment'] != null &&
//                                widget.data['photoAttachment'] != "''"
////                                ?Text(data['photoAttachment']):Text('null')
//                                ? Image.network(widget.data['photoAttachment'])
//                                : Image.asset('assets/profile.png'),
//                          )),
//                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.data['fullName'],
                              style: TextStyle(
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.data['designation']['value'],
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    userType == 0 ?Center(
                      child: InkWell(
                        child: Text(updateImage?'Choose another':'Update image', style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),),
                        onTap: () {
                          imageSelectorGallery();
//                          _pickingType = FileType.IMAGE;
//                          _extension = 'jpg|jpeg|png';
//                          _getSelectedFile();
                        },
                      ),
                    ):SizedBox(
                      width:0.0,height: 0.0,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    SizedBox(height: 10.0),
                    updateImage ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            width: 100.0,
                            height: 30.0,
                            color: Theme
                                .of(context)
                                .buttonColor,
                            child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                          onTap: () async {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        InkWell(
                          child: Container(
                            width: 100.0,
                            height: 30.0,
                            color: Theme
                                .of(context)
                                .buttonColor,
                            child: Center(
                                child: Text(
                                  'Update',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                          onTap: () async {
                            if (_imagePaths != null) {
//                              FormData formData = new FormData.from({"photoAttachment": new UploadFileInfo(new File(_imagePaths), _fileName),});
                              FormData formData = FormData.fromMap({"selfie": await MultipartFile.fromFile(_imagePaths,filename:_fileName),});
                              updateEmployeePic(formData);
                            }
                          },
                        )
                      ],
                    ) : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            width: 100.0,
                            height: 30.0,
                            color: Theme
                                .of(context)
                                .buttonColor,
                            child: Center(
                                child: Text(
                                  'Ok',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                          onTap: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ))
      // _filterOptions(context),
    );
  }
}
