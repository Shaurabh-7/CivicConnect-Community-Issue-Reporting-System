package civicconnect.daoInterface;

import civicconnect.model.Categories;
import java.util.ArrayList;

public interface categoryInterface {
    boolean addCategory(Categories category);
    boolean updateCategory(Categories category);
    boolean deleteCategory(int id);
    Categories getCategoryById(int id);
    ArrayList<Categories> getAllCategories();
    int getTotalCategoriesCount();
}
