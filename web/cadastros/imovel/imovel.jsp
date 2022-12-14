<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="iso-8859-1" %>
<jsp:include page="/header.jsp" />
<jsp:include page="/cadastros/menuLogado.jsp"/>

<div class="container-fluid">
    <!-- Page Heading -->
    <h1 class="h3 mb-2 text-gray-800">Imovel</h1>
    <p class="mb-4">Planilha de Registros</p>
    <a href="#modaladicionar" class="btn btn-success mb-4 adicionar" data-toggle="modal" data-ad="" onclick="setDadosModal(${0})">
        <i class="fas fa-plus fa-fw"></i>Adicionar</a>
    <div class="card shadow">
        <div class="card-body">
            <table id="datatable" class="display">
                <thead>
                    <tr>
                        <th align="center">ID</th>
                        <th align="center">Descrição</th>
                        <th align="center">Endereço</th>
                        <th align="center">Valor do Aluguel</th>
                        <th align="center">Alterar</th>
                        <th align="center">Excluir</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="imovel" items="${imoveis}">
                        <tr>
                            <td align="center">${imovel.idImovel}</td>
                            <td align="center">${imovel.descricao}</td>
                            <td align="center">${imovel.endereco}</td>
                            <td align="center">${imovel.valorAluguel}</td>
                            <td align="center">
                                <a href="#modaladicionar" class="btn btn-success adicionar" data-toggle="modal"
                                   data-id="" onclick="setDadosModal(${imovel.idImovel})">
                                    <i class="fas fa-plus fa-fw"></i> Alterar </a>
                            </td>
                            <td align="center">
                                <a href="#" onclick="deletar(${imovel.idImovel})">
                                    <button class="btn btn-danger"><i class="fas fa-fw fa-times"></i>
                                        <Strong>Excluir</Strong>
                                    </button></a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal fade" id="modaladicionar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-x1">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Adicionar</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">

                    <div class="form-group">
                        <input class="form-control" type="hidden" name="idimovel" id="idimovel" value="" readonly="readonly"/>
                    </div>

                    <div class="form-group">
                        <label>Descrição</label>
                        <input class="form-control" type="text" name="descricao" id="descricao" value=""/>
                    </div>

                    <div class="form-group">
                        <label>Endereço</label>
                        <input class="form-control" type="text" name="endereco" id="endereco" value=""/>
                    </div>

                    <div class="form-group">
                        <label>Valor do Aluguel</label>
                        <input class="form-control" type="text" name="valoraluguel" id="valoraluguel" value=""/>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                        <a href="#" onclick="validarCampos()">
                            <button type="button" class="btn btn-success">Salvar</button>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style type="text/css">
    .inputfile{
        /* visibility: hidden etc. wont work */
        width: 0.1px;
        height: 0.1px;
        opacity: 0;
        overflow: hidden;
        position: absolute;
        z-index: -1;}
    .inputfile:focus + label{
        /* keyboard navigation */
        outline: 1px dotted #000;
        outline: -webkit-focus-ring-color auto 5px;}
    .inputfile + label * {
        pointer-events: none;}
    .borda{
        position: relative;
        margin: 0 20px 30px 0;
        padding: 10px;
        border: 1px solid #e1e1e1;
        border-radius: 3px;
        background: #fff;
        -webkit-box-shadow: 0px 0px 3px rgba(0,0,0,0.06);
        -moz-box-shadow: 0px 0px 3px rgba(0,0,0,0.06);
        box-shadow: 0px 0px 3px rgba(0,0,0,0.06);}
</style>

<script>
    $(document).ready(function () {
        console.log('entrei ready');
        //Carregamos a datatable
        $('#datatable').DataTable({
            "oLanguage": {
                "sProcessing": "Processando...",
                "sLengthMenu": "Mostrar _MENU_ registros",
                "sZeroRecords": "Nenhum registro encontrado.",
                "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ registros",
                "sInfoEmpty": "Mostrando de 0 até 0 de 0 registros",
                "sInfoFiltered": "",
                "sinfoPostFix": "",
                "sSearch": "Buscar:",
                "sUrl": "",
                "oPaginate": {
                    "sFirst": "Primeiro",
                    "sPrevious": "Anterior",
                    "sNext": "Seguinte",
                    "sLast": "Último"
                }
            }
        });
    });

    var cidade = '';
    function limparDadosModal() {
        $('#idimovel').val("0");
        $('#descricao').val("");
        $('#endereco').val("");
        $('#valoraluguel').val("0");
    }

    function setDadosModal(valor) {
        limparDadosModal();
        document.getElementById('idimovel').value = valor;
        var idImovel = valor;
        if (idImovel != "0") {
            $.getJSON('ImovelCarregar', {idImovel: idImovel}, function (respostaServlet) {
                console.log(respostaServlet);
                var id = respostaServlet.idImovel;
                if (id != "0") {
                    $('#idimovel').val(respostaServlet.idImovel);
                    $('#descricao').val(respostaServlet.descricao);
                    $('#endereco').val(respostaServlet.endereco);
                    $('#valoraluguel').val(respostaServlet.valorAluguel);
                }
            });
        }
    }

    function deletar(codigo) {
        var id = codigo;
        console.log(codigo);

        Swal.fire({
            title: 'Você tem certeza?',
            text: 'Você deseja realmente excluir o imovel?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Sim, excluir o imovel',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    type: 'post',
                    url: '${pageContext.request.contextPath}/ImovelExcluir',
                    data: {
                        idImovel: id
                    },
                    success:
                            function (data) {
                                if (data == 1) {
                                    Swal.fire({
                                        position: 'center',
                                        icon: 'success',
                                        title: 'Sucesso',
                                        text: 'Imovel excluido com sucesso!',
                                        showConfirmButton: true,
                                        timer: 10000
                                    }).then(function () {
                                        window.location.href = "${pageContext.request.contextPath}/ImovelListar";
                                    })
                                } else {
                                    Swal.fire({
                                        position: 'center',
                                        icon: 'error',
                                        title: 'Erro',
                                        text: 'Não foi possível excluir o imovel!',
                                        showConfirmButton: true,
                                        timer: 10000
                                    }).then(function () {
                                        window.location.href = "${pageContext.request.contextPath}/ImovelListar";
                                    })
                                }
                            },
                    error:
                            function (data) {
                                window.location.href = "${pageContext.request.contextPath}/ImovelListar";
                            }
                });
            }
            ;
        });
    }

    function validarCampos() {
        console.log("entrei na validação de campos");
        if (document.getElementById("descricao").value == '') {
            Swal.fire({
                position: 'center',
                icon: 'error',
                title: 'Verifique a descrição do Imovel',
                showConfirmButton: true,
                timer: 2000
            });
            $("#descricao").focus();
        } else if (document.getElementById("endereco").value == '') {
            Swal.fire({
                position: 'center',
                icon: 'error',
                title: 'Verifique o endereço do Imovel',
                showConfirmButton: true,
                timer: 2000
            });
            $("#descricao").focus();
        } else if (document.getElementById("valoraluguel").value == '') {
            Swal.fire({
                position: 'center',
                icon: 'error',
                title: 'Verifique o valor do aluguel do Imovel',
                showConfirmButton: true,
                timer: 2000
            });
            $("#descricao").focus();
        } else {
            gravarDados();
        }
    }

    function gravarDados() {
        console.log("Gravando dados ....");

        $.ajax({
            type: 'post',
            url: 'ImovelCadastrar',
            data: {
                idimovel: $('#idimovel').val(),
                descricao: $('#descricao').val(),
                endereco: $("#endereco").val(),
                valoraluguel: $("#valoraluguel").val()
            },
            success:
                    function (data) {
                        console.log("reposta servlet->");
                        console.log(data);
                        if (data == 1) {
                            Swal.fire({
                                position: 'center',
                                icon: 'success',
                                title: 'Sucesso',
                                text: 'Imovel gravado com sucesso!',
                                showConfirmButton: true,
                                timer: 10000
                            }).then(function () {
                                window.location.href = "${pageContext.request.contextPath}/ImovelListar";
                            })
                        } else {
                            Swal.fire({
                                position: 'center',
                                icon: 'error',
                                title: 'Erro',
                                text: 'Não foi possível gravar o Imovel!',
                                showConfirmButton: true,
                                timer: 10000
                            }).then(function () {
                                window.location.href = "${pageContext.request.contextPath}/ImovelListar";
                            })
                        }
                    },
            error:
                    function (data) {
                        window.location.href = "${pageContext.request.contextPath}/ImovelListar";
                    }
        });
    }

</script>
<%@include file="/footer.jsp"%>