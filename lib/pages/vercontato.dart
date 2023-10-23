import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:listacontatos/model/contato_model.dart';
import 'package:listacontatos/pages/home_page.dart';
import 'package:listacontatos/repository/back4app_repository.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listacontatos/Theme/theme.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';

class ContatoPage extends StatefulWidget {
  final ContatoModel contato;
  const ContatoPage({Key? key, required this.contato}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ContatoPageState createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  // final TextEditingController _controllerNome = TextEditingController();
  // final TextEditingController _controllerTelefone = TextEditingController();
  // final focus = FocusNode();
  // File? imagePath;
  XFile? photo;

  // Back4appRepository repository = Back4appRepository();

  cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      await GallerySaver.saveImage(croppedFile.path);
      photo = XFile(croppedFile.path);
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lista de Contatos',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                decoration: BoxDecoration(
                  color: ThemeCustom.of(context).secondaryBackground,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 8, 20, 0),
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(
                                    thickness: 3,
                                    indent: 150,
                                    endIndent: 150,
                                    color: ThemeCustom.of(context)
                                        .primaryBackground,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFDBE2E7),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(4, 4, 4, 4),
                                                child: Container(
                                                  width: 120,
                                                  height: 120,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: (widget.contato
                                                              .imagePath ==
                                                          null)
                                                      ? Image.network(
                                                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDJ8fHBlcnNvbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.file(
                                                          File(widget.contato
                                                                  .imagePath
                                                              as String),
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 24, 0, 44),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            child: const Text("Adicionar foto"),
                                            onPressed: () async {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (_) {
                                                    return Wrap(
                                                      children: [
                                                        ListTile(
                                                          leading: const Icon(
                                                              Icons.camera),
                                                          title: const Text(
                                                              "Camera"),
                                                          onTap: () async {
                                                            final ImagePicker
                                                                _picker =
                                                                ImagePicker();
                                                            photo = await _picker
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .camera);
                                                            if (photo != null) {
                                                              String path =
                                                                  (await path_provider
                                                                          .getApplicationDocumentsDirectory())
                                                                      .path;
                                                              String name =
                                                                  p.basename(
                                                                      photo!
                                                                          .path);
                                                              await photo!.saveTo(
                                                                  "$path/$name");

                                                              await GallerySaver
                                                                  .saveImage(
                                                                      photo!
                                                                          .path);
                                                              setState(() {});

                                                              cropImage(photo!);
                                                            }
                                                          },
                                                        ),
                                                        ListTile(
                                                            leading: const Icon(
                                                                Icons
                                                                    .image_search),
                                                            title: const Text(
                                                                "Galeria"),
                                                            onTap: () async {
                                                              final ImagePicker
                                                                  _picker =
                                                                  ImagePicker();
                                                              photo = await _picker
                                                                  .pickImage(
                                                                      source: ImageSource
                                                                          .gallery);

                                                              setState(() {});

                                                              cropImage(photo!);
                                                            })
                                                      ],
                                                    );
                                                  });
                                            },
                                          ),
                                        ]),
                                  ),
                                  Center(
                                    child: Column(
                                    
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                    
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 8),
                                          child: Text(
                                            "Nome",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Text(
                                          widget.contato.nome,
                                          style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.black),
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 8),
                                          child: Text(
                                            "Telefone",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Text(
                                          widget.contato.telefone,
                                          style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.black),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => {},
                                          child: const Text("Alterar"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomePage(
                                                          title:
                                                              "Lista de Contato",
                                                        )));
                                          },
                                          child: const Text("Cancelar"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
