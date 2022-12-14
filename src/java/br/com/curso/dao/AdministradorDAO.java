/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.curso.dao;

import br.com.curso.model.Administrador;
import br.com.curso.model.Cidade;
import br.com.curso.utils.SingleConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author bruno
 */
public class AdministradorDAO implements GenericDAO {

    private Connection conexao;

    public AdministradorDAO() throws Exception {
        conexao = SingleConnection.getConnection();
    }

    @Override
    public Boolean cadastrar(Object objeto) {
        Boolean retorno = false;
        try {
            Administrador oAdministrador = (Administrador) objeto;
            if (oAdministrador.getIdAdministrador() == 0) {//inserção
                //verifica se já existe pessoa com este CPF cadastrada.
                int idAdministrador = this.verificarCpf(oAdministrador.getCpfCnpj());
                if (idAdministrador == 0) {
                    //se não encontrou insere
                    retorno = this.inserir(oAdministrador);
                } else {
                    //se encontrou administrador com o cpf altera
                    oAdministrador.setIdAdministrador(idAdministrador);
                    retorno = this.alterar(oAdministrador);
                }
            } else {
                retorno = this.alterar(oAdministrador);
            }
        } catch (Exception ex) {
            System.out.println("Problmas ao incluir administrador na DAO! Erro " + ex.getMessage());
        }
        return retorno;
    }

    public int verificarCpf(String cpf) {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int idAdministrador = 0;
        String sql = "select c.* from administrador c, pessoa p where c.idpessoa = p.idpessoa and p.cpfcnpj=?";
        try {
            stmt = conexao.prepareStatement(sql);
            stmt.setString(1, cpf);
            rs = stmt.executeQuery();
            while (rs.next()) {
                idAdministrador = rs.getInt("idadministrador");
            }
            return idAdministrador;
        } catch (SQLException ex) {
            System.out.println("Problemas ao carregar pessoa! Erro: " + ex.getMessage());
            return idAdministrador;
        }
    }

    @Override
    public Boolean inserir(Object objeto) {
        Administrador oAdministrador = (Administrador) objeto;
        PreparedStatement stmt = null;
        String sql = "insert into administrador (idpessoa, situacao, permitelogin) values (?,?,?)";
        try {
            PessoaDAO oPessoaDAO = new PessoaDAO();
            //manda informções para o cadastrar de pessoa.
            int idPessoa = oPessoaDAO.cadastrar(oAdministrador);
            stmt = conexao.prepareStatement(sql);
            stmt.setInt(1, idPessoa);
            stmt.setString(2, "A");
            stmt.setString(3, oAdministrador.getPermiteLogin());
            stmt.execute();
            conexao.commit();
            return true;
        } catch (Exception e) {
            try {
                System.out.println("Problemas ao cadastrar Administrador na DAO! Erro:" + e.getMessage());
                e.printStackTrace();
                conexao.rollback();
            } catch (SQLException ex) {
                System.out.println("Problemas ao executar rollback " + ex.getMessage());
                ex.printStackTrace();
            }
            return false;
        }
    }

    @Override
    public Boolean alterar(Object objeto) {
        Administrador oAdministrador = (Administrador) objeto;
        PreparedStatement stmt = null;
        String sql = "update administrador set permitelogin=? where idadministrador=?";
        try {
            PessoaDAO oPessoaDAO = new PessoaDAO();
            oPessoaDAO.cadastrar(oAdministrador); //envia para classe PessoaDAO
            stmt = conexao.prepareStatement(sql);
            stmt.setString(1, oAdministrador.getPermiteLogin());
            stmt.setInt(2, oAdministrador.getIdAdministrador());
            stmt.execute();
            conexao.commit();
            return true;
        } catch (Exception e) {
            try {
                System.out.println("Problema ao alterar Administrador na DAO! Erro: " + e.getMessage());
                e.printStackTrace();
                conexao.rollback();
            } catch (SQLException ex) {
                System.out.println("Problemas ao executar rollback " + ex.getMessage());
                ex.printStackTrace();
            }
            return false;
        }
    }

    @Override
    public Boolean excluir(int numero) {
        PreparedStatement stmt = null;
        try {
            //carrega dados de admintrador
            AdministradorDAO oAdministradorDAO = new AdministradorDAO();
            Administrador oAdministrador = (Administrador) oAdministradorDAO.carregar(numero);
            String situacao = "A";//verifica e troca a situação do Administrador
            if (oAdministrador.getSituacao().equals(situacao)) {
                situacao = "I";
            } else {
                situacao = "A";
            }

            String sql = "update administrador set situacao=? where idadministrador=?";
            stmt = conexao.prepareStatement(sql);
            stmt.setString(1, situacao);
            stmt.setInt(2, oAdministrador.getIdAdministrador());
            stmt.execute();
            conexao.commit();
            return true;
        } catch (Exception e) {
            try {
                System.out.println("Problema ao excluir Administrador na DAO! Erro: " + e.getMessage());
                e.printStackTrace();
                conexao.rollback();
            } catch (SQLException ex) {
                System.out.println("Problemas ao executar rollback " + ex.getMessage());
                ex.printStackTrace();
            }
            return false;
        }
    }

    @Override
    public Object carregar(int numero) {
        int idAdministrador = numero;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Administrador oAdministrador = null;
        String sql = "select * from administrador c, pessoa p where c.idpessoa = p.idpessoa and c.idadministrador = ?";
        try {
            stmt = conexao.prepareStatement(sql);
            stmt.setInt(1, idAdministrador);
            rs = stmt.executeQuery();
            while (rs.next()) {
                //busca cidade
                Cidade oCidade = null;
                try {
                    CidadeDAO oCidadeDAO = new CidadeDAO();
                    oCidade = (Cidade) oCidadeDAO.carregar(rs.getInt("idcidade"));
                } catch (Exception ex) {
                    System.out.println("Problemas ao carregar cidade da AdministradorDAO! Erro " + ex.getMessage());
                }

                oAdministrador = new Administrador(rs.getInt("idadministrador"),
                        rs.getString("permitelogin"),
                        rs.getString("situacao"),
                        rs.getInt("idpessoa"),
                        rs.getString("cpfcnpj"),
                        rs.getString("nome"),
                        rs.getDate("datanascimento"),
                        oCidade,
                        rs.getString("login"),
                        rs.getString("senha"),
                        rs.getString("foto"));
            }
        } catch (SQLException e) {
            System.out.println("Problemas ao carregar Administrador na DAO! Erro " + e.getMessage());
            e.printStackTrace();
        }
        return oAdministrador;
    }

    @Override
    public List<Object> listar() {
        List<Object> resultado = new ArrayList<>();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String sql = "select p.*, c.idadministrador, c.situacao, c.permitelogin from administrador c, pessoa p where c.idpessoa = p.idpessoa order by idpessoa";
        try {
            stmt = conexao.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Cidade oCidade = null;//busca cidade
                try {
                    CidadeDAO oCidadeDAO = new CidadeDAO();
                    oCidade = (Cidade) oCidadeDAO.carregar(rs.getInt("idcidade"));
                } catch (Exception ex) {
                    System.out.println("Problemas ao carregar cidade no AdministradorDAO! Erro: " + ex.getMessage());
                }
                Administrador oAdministrador = new Administrador(rs.getInt("idadministrador"),
                        rs.getString("permitelogin"),
                        rs.getString("situacao"),
                        rs.getInt("idpessoa"),
                        rs.getString("cpfcnpj"),
                        rs.getString("nome"),
                        rs.getDate("datanascimento"),
                        oCidade,
                        rs.getString("login"),
                        rs.getString("senha"),
                        rs.getString("foto"));
                resultado.add(oAdministrador);
            }
        } catch (SQLException ex) {
            System.out.println("Problemas ao listar administrador! Erro: " + ex.getMessage());
        }
        return resultado;
    }

}
