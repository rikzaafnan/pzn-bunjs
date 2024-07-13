import {describe, it, expect} from 'bun:test'
import {sayHello} from "../src/hello.ts";
import {User} from "user/user.ts";

describe('user package',()=> {
    it('should accesses from main packages', async () => {
        const user = new User("afgan")
        expect(user.name).toBe(`afgan`)

    });


})