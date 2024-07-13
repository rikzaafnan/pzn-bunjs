import {describe, it, expect} from 'bun:test'
import {sayHello} from "../src/hello.ts";

describe('Bun Test Runner',()=> {
    it('should support unit test', async () => {
       const response = sayHello("test")
        expect(response).toBe(`Hello test`)
    });

    it('should support unit test with budi', async () => {
        const response = sayHello("test budi")
        expect(response).toBe(`Hello test budi`)
    });
})