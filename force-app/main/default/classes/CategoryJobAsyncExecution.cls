public class CategoryJobAsyncExecution implements Queueable {
    
    public Id categoryId;
    
    public CategoryJobAsyncExecution(Id categoryId) {
        this.categoryId = categoryId;
    }
    
    public void execute(QueueableContext context) {
        Apttus_Config2.HierarchyViewUpdateJob hvuj = new Apttus_Config2.HierarchyViewUpdateJob(this.categoryId); 
        Database.executebatch(hvuj);           
    }
}