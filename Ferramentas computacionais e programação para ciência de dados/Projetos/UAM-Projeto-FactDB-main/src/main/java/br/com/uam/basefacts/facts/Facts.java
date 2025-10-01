package br.com.uam.basefacts.facts;

import jakarta.persistence.*;

@Entity
@Table
public class Facts {

    // Definir que o ID é a chave primária
    @Id
    // Gerar um sequencial
    @SequenceGenerator(
            name= "facts_sequence",
            sequenceName = "facts_sequence",
            allocationSize = 1
    )
    // Gerar o ID e defini-lo como sequencial pelo banco de dados (Postgres)
    @GeneratedValue(
            strategy= GenerationType.SEQUENCE,
            generator = "facts_sequence"
    )
    private Long id;
    private String url;
    private String userEmail;

    @Transient
    private boolean check;

    public Facts (Long id, String url, String userEmail) {
        this.id = id;
        this.url = url;
        this.userEmail = userEmail;
    }

    // Sem o ID

    public Facts (String url, String userEmail) {
        this.url = url;
        this.userEmail = userEmail;
    }

    public Facts() {

    }

    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public boolean isCheck() {
        return check;
    }

    public void setCheck(boolean check) {
        this.check = check;
    }

    // toString

    public String toString() {
        return "Facts{" +
                "id=" + id +
                ", url='" + url + '\'' +
                ", userEmail='" + userEmail + '\'' +
                '}';
    }

}


