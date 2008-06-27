package org.compass.core.test.json.object.dynamic;

import org.compass.core.CompassSession;
import org.compass.core.CompassTransaction;
import org.compass.core.Resource;
import org.compass.core.json.RawAliasedJsonObject;
import org.compass.core.test.AbstractTestCase;

/**
 * @author kimchy
 */
public class SimpleJsonDynamicObjectTests extends AbstractTestCase {

    protected String[] getMappings() {
        return new String[]{"json/object/dynamic/mapping.cpm.xml"};
    }

    public void testSimpleDynamicJsonObject() {
        CompassSession session = openSession();
        CompassTransaction tr = session.beginTransaction();

        RawAliasedJsonObject jsonObject = new RawAliasedJsonObject("a", "{id : 1, value : \"test\", obj : { objValue1 : \"4\", arr : [1, 2]}}");
        session.save(jsonObject);

        Resource resource = session.loadResource("a", 1);
        assertEquals("test", resource.getValue("value"));
        assertEquals("4", resource.getValue("objValue1"));
        assertEquals(2, resource.getProperties("arr").length);
        assertEquals("1", resource.getValues("arr")[0]);
        assertEquals("2", resource.getValues("arr")[1]);

        tr.commit();
        session.close();
    }

    public void testNoJsonObjectMappingDynamicJsonObject() {
        CompassSession session = openSession();
        CompassTransaction tr = session.beginTransaction();

        RawAliasedJsonObject jsonObject = new RawAliasedJsonObject("b", "{id : 1, value : \"test\", obj : { objValue1 : \"4\", arr : [1, 2]}}");
        session.save(jsonObject);

        Resource resource = session.loadResource("b", 1);
        assertEquals("test", resource.getValue("value"));
        assertEquals("4", resource.getValue("objValue1"));
        assertEquals(2, resource.getProperties("arr").length);
        assertEquals("1", resource.getValues("arr")[0]);
        assertEquals("2", resource.getValues("arr")[1]);

        tr.commit();
        session.close();
    }
}