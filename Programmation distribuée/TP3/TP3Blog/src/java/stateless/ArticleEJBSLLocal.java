/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stateless;

import entities.Article;
import java.util.List;

/**
 *
 * @author benjy
 */
public interface ArticleEJBSLLocal{
    public void saveArticle( Article unArticle );
    public List<Article> getArticles();
    public Article getArticle( Long unId );
    public void majArticle( Long unId, Article unArticle );
}
