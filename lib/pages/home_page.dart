import 'dart:io';

import 'package:flutter/material.dart';
import 'package:listacontatos/Theme/theme.dart';
import 'package:listacontatos/model/contato_model.dart';
import 'package:listacontatos/pages/addcontato.dart';
import 'package:listacontatos/pages/vercontato.dart';
import 'package:listacontatos/repository/back4app_repository.dart';
import 'package:listacontatos/repository/back4app_repository_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controllerPesquisa = TextEditingController();
  Back4appRepositoryModel contatos = Back4appRepositoryModel();
  Back4appRepository repository = Back4appRepository();
  List<ContatoModel>? dados = <ContatoModel>[];
  List<ContatoModel>? dadospesquisa = <ContatoModel>[];
  bool pesquisaativa = false;


  @override
  void initState() {
    super.initState();
    obterContatos();
  }

  void obterContatos() async {
    contatos = await repository.obterContatos();
    dados = contatos.contatos;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Contatos'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
              child: Text(
                'Lista de Contatos',
                style: ThemeCustom.of(context).headlineMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: ThemeCustom.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: ThemeCustom.of(context).alternate,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 0, 12, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.search_rounded,
                                color: ThemeCustom.of(context).secondaryText,
                                size: 24,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      4, 0, 0, 0),
                                  child: TextField(
                                    onSubmitted: (value) {
                                      if (dados != null) {
                                        dadospesquisa = [];
                                        for (var element in dados!) {
                                          if (element.nome
                                              .toLowerCase()
                                              .contains(value.toLowerCase())) {
                                            dadospesquisa?.add(element);
                                            setState(() {
                                              pesquisaativa = true;
                                            });
                                          }
                                        }
                                      }
                                    },
                                    textCapitalization:
                                        TextCapitalization.words,
                                    
                                    controller: controllerPesquisa,
                                    obscureText: false,
                                    cursorColor: Colors.black,
                                    
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            controllerPesquisa.clear();
                                            setState(() {
                                              pesquisaativa = false;
                                            });
                                          }),
  
                                      labelText: 'Pesquisar contatos...',
                                      hintStyle:
                                          ThemeCustom.of(context).bodyLarge,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    
                                    
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: (contatos.contatos != null)
                  ? SizedBox(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * .7 -
                          MediaQuery.of(context).viewInsets.bottom,
                      child: !pesquisaativa
                          ? ListView.builder(
                          itemCount: contatos.contatos!.length,
                          itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ContatoPage(
                                                contato: contatos
                                                    .contatos![index])));
                                  },
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8, 8, 8, 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: (contatos
                                                  .contatos![index].imagePath !=
                                              "")
                                          ? Image.file(
                                              File(contatos.contatos![index]
                                                      .imagePath ??
                                                  ""),
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover)
                                          : Image.network(
                                              "https://cbissn.ibict.br/images/phocagallery/galeria2/thumbs/phoca_thumb_l_image03_grd.png",
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12, 0, 0, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            contatos.contatos![index].nome,
                                            style: ThemeCustom.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  color: ThemeCustom.of(context)
                                                      .secondaryText,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          Text(
                                            contatos.contatos![index].telefone,
                                            style: ThemeCustom.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  color: ThemeCustom.of(context)
                                                      .secondaryText,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: ThemeCustom.of(context)
                                            .secondaryBackground,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 4, 4, 4),
                                        child: Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          color: ThemeCustom.of(context)
                                              .secondaryText,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                              })
                          : ListView.builder(
                              itemCount: dadospesquisa!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ContatoPage(
                                                contato: contatos
                                                    .contatos![index])));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8, 8, 8, 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: (dadospesquisa![index]
                                                      .imagePath !=
                                                  "")
                                              ? Image.file(
                                                  File(dadospesquisa![index]
                                                          .imagePath ??
                                                      ""),
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover)
                                              : Image.network(
                                                  "https://cbissn.ibict.br/images/phocagallery/galeria2/thumbs/phoca_thumb_l_image03_grd.png",
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12, 0, 0, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dadospesquisa![index].nome,
                                                style: ThemeCustom.of(context)
                                                    .titleMedium
                                                    .override(
                                                      fontFamily: 'Readex Pro',
                                                      color: ThemeCustom.of(
                                                              context)
                                                          .secondaryText,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                              Text(
                                                dadospesquisa![index].telefone,
                                                style: ThemeCustom.of(context)
                                                    .bodySmall
                                                    .override(
                                                      fontFamily: 'Readex Pro',
                                                      color: ThemeCustom.of(
                                                              context)
                                                          .secondaryText,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: ThemeCustom.of(context)
                                                .secondaryBackground,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(4, 4, 4, 4),
                                            child: Icon(
                                              Icons
                                                  .keyboard_arrow_right_rounded,
                                              color: ThemeCustom.of(context)
                                                  .secondaryText,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                    )
                  : Container(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangePhotoWidget()));
            // await showModalBottomSheet(
            //   isScrollControlled: true,
            //   backgroundColor: Colors.transparent,
            //   enableDrag: false,
            //   context: context,
            //   builder: (context) {
            //     return const ChangePhotoWidget();
            //   },
            // );
          },
          backgroundColor: ThemeCustom.of(context).primary,
          elevation: 8,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
