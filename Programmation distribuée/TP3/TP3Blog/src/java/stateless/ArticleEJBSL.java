/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stateless;

import entities.Article;
import java.util.List;
import javax.ejb.Stateless;
import javax.jws.WebService;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

/**
 *
 * @author benjy
 */
@Stateless
@Path("article")
public class ArticleEJBSL  implements ArticleEJBSLLocal{
    private EntityManager em;
    
    public ArticleEJBSL(){
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("TP3Blog");
        em = factory.createEntityManager();
    }

    @Override
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public void saveArticle(Article unArticle) {
        em.persist( unArticle );
    }

    @Override
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Article> getArticles() {       
        em.getTransaction().begin();
        List<Article> listArticles = em.createQuery("SELECT * FROM DBUSER.ARTICLE").getResultList();
        
        return( listArticles );
    }

    @Override
    @Path("/{id}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Article getArticle(@PathParam("id")Long unId) {
        return em.getReference( Article.class, unId );
    }

    @Override
    @Path("/{id}")
    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    public void majArticle(@PathParam("id")Long unId, Article unArticle) {
        em.remove( em.getReference( Article.class, unId ) );
        em.persist( unArticle );
    }
    // Add business logic below. (Right-click in editor and choose
    // "Insert Code > Add Business Method")
    
}
