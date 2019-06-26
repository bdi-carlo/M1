package entities;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.2.v20140319-rNA", date="2019-03-25T18:32:20")
@StaticMetamodel(Commentaire.class)
public class Commentaire_ { 

    public static volatile SingularAttribute<Commentaire, Date> cdate;
    public static volatile SingularAttribute<Commentaire, Long> id;
    public static volatile SingularAttribute<Commentaire, String> contenu;
    public static volatile SingularAttribute<Commentaire, String> email;

}