/*
 * Copyright 2004-2008 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.compass.core.test.json.object;

import org.compass.core.config.CompassConfiguration;
import org.compass.core.mapping.json.NamingType;
import static org.compass.core.mapping.json.builder.JSEM.*;

/**
 * @author kimchy
 */
public class SimpleJsonObjectBuilderTests extends SimpleJsonObjectTests {

    @Override
    protected String[] getMappings() {
        return new String[0];
    }

    @Override
    protected void addExtraConf(CompassConfiguration conf) {
        conf.addResourceMapping(
                json("a")
                        .add(id("id"))
                        .add(property("value"))
                        .add(object("obj").add(property("objValue1").valueConverter("int")).add(array("arr").element(property().valueConverter("int"))))
        );
        conf.addResourceMapping(
                json("b")
                        .add(id("id"))
                        .add(property("value"))
                        .add(object("obj").add(property("objValue1").valueConverter("int")).add(array("arr").element(property().valueConverter("int"))))
                        .add(object("obj").add(property("objValue1").valueConverter("int")).add(array("arr").element(property().valueConverter("int"))))
        );
        conf.addResourceMapping(
                json("c")
                        .add(id("id"))
                        .add(property("value"))
                        .add(object("obj").add(property("objValue1").namingType(NamingType.FULL).valueConverter("int")).add(array("arr").element(property().namingType(NamingType.FULL).valueConverter("int"))))
        );
    }
}
